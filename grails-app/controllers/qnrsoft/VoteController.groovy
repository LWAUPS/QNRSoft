package qnrsoft

class VoteController {

    def show(Long id) {
		def quizzInstance = Quizz.get(id)
		if (!quizzInstance || quizzInstance.state != Quizz.STATE_VOTING) {
			render(view: "/error.gsp")
			return
		}
		
		[quizzInstance: quizzInstance]
	}	
	
	def submit(Long id) {
		def quizzInstance = Quizz.get(id)
		def checkedAnswers = params.list('checkAnswers')
		def selectedAnswers = Answer.getAll(checkedAnswers)
		
		if (selectedAnswers.isEmpty()) {
			flash.error = "You have to select at least one answer."
			redirect(action: "show", id: id)
			return
		}
		
		quizzInstance.voteCount++
		quizzInstance.save()
		
		for (Answer answer : selectedAnswers) {
			answer.voteCount++
			answer.save()
		}
		
		flash.message = "Vote accepted."
		redirect(controller:"quizz", action: "list")
	}
	
	def reopen(Long id) {
		def quizzInstance = Quizz.get(id)
		
		if (!quizzInstance) {
			render(view: "/error.gsp")
			return
		}
		
		if (quizzInstance.state == Quizz.STATE_OPENED) {
			flash.message = "The quizz is already in state 'Opened'."
		}
		else {
			quizzInstance.state = Quizz.STATE_OPENED
			//TODO save cascade
			quizzInstance.save()
			flash.message = "Quizz state set to 'Opened'."
		}
		
		redirect(controller: "quizz", action: "show", id: id)
	}
	
	def start(Long id) {
		def quizzInstance = Quizz.get(id)
		
		if (!quizzInstance) {
			render(view: "/error.gsp")
			return
		}
		
		if (quizzInstance.state == Quizz.STATE_VOTING) {
			flash.message = "Quizz already in state 'Voting'"
		}
		else {
			quizzInstance.state = Quizz.STATE_VOTING
			//TODO save cascade
			quizzInstance.save()
			flash.message = "Quizz state set to 'Voting'"
		}
		
		redirect(controller: "quizz", action: "show", id: id)
	}
	
	def end(Long id) {
		def quizzInstance = Quizz.get(id)
		
		if (!quizzInstance) {
			render(view: "/error.gsp")
			return
		}
		
		if (quizzInstance.state == Quizz.STATE_CLOSED) {
			flash.error = "Voting phase is already over."
		}
		else {
			quizzInstance.state = Quizz.STATE_CLOSED
			//TODO save cascade
			quizzInstance.save()
			flash.message = "Voting phase over."
		}
		
		redirect(controller: "quizz", action: "show", id: id)
	}
}
