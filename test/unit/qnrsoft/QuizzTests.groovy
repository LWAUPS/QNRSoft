package qnrsoft



import grails.test.mixin.*
import org.junit.*

/**
 * See the API for {@link grails.test.mixin.domain.DomainClassUnitTestMixin} for usage instructions
 */
@TestFor(Quizz)
class QuizzTests {

    void testConstraints() {
       def q = new Quizz()
	   
	   assert !q.validate()
    }
}
