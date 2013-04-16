package qnrsoft

import org.springframework.dao.DataIntegrityViolationException
import org.apache.shiro.SecurityUtils

class StatsController {

    def show(Long id) {
		def quizzInstance = Quizz.get(id)
		if (!quizzInstance) {
			render(view: "/error.gsp")
			return
		}
		
		if (quizzInstance.state != Quizz.STATE_CLOSED) {
			flash.error = "The vote must be in state 'Closed' to display statistics."
			redirect(controller: "quizz", action: "show", id: id)
			return
		}
		
		if (quizzInstance.voteCount < 1) {
			flash.message = "The quizz must have at least one vote to build statistics."
			
			if (SecurityUtils.getSubject().hasRole("ROLE_TEACHER")) {
				redirect(controller: "quizz", action: "show", id: id)
			}
			else {
				redirect(controller: "quizz", action: "list")
			}
			return
		}
		
		[quizzInstance: quizzInstance]
	}
}