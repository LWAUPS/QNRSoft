
<%@ page import="qnrsoft.Quizz" %>
<%@ page import="qnrsoft.Answer" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<title>QnR - Quizz #${quizzInstance?.id}</title>
	</head>
	<body>
		<a href="#show-quizz" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="list" action="list">Quizz List</g:link></li>
				<shiro:isLoggedIn><li class="log"><g:link controller="auth" action="signOut"><g:message code="default.logout.label" default="Logout" /></g:link></li></shiro:isLoggedIn>
			</ul>
		</div>
		<div id="show-quizz" class="content scaffold-show" role="main">
			<h1>Quizz #${quizzInstance?.id}</h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<g:if test="${flash.error}">
			<div class="errors" role="status">${flash.error}</div>
			</g:if>
			<ol class="property-list quizz">
			
				<g:if test="${quizzInstance?.question}">
				<li class="fieldcontain">
					<span id="question-label" class="property-label"><g:message code="quizz.question.label" default="Question" /></span>
					
					<span class="property-value" aria-labelledby="question-label"><g:fieldValue bean="${quizzInstance}" field="question"/></span>
					
				</li>
				</g:if>
			
				
				<li class="fieldcontain">
					<span id="onScreen-label" class="property-label"><g:message code="quizz.onScreen.label" default="On Screen" /></span>
					
					<span class="property-value" aria-labelledby="onScreen-label"><g:formatBoolean boolean="${quizzInstance?.onScreen}" /></span>
					
				</li>
		
			
				<g:if test="${quizzInstance?.state}">
				<li class="fieldcontain">
					<span id="state-label" class="property-label"><g:message code="quizz.state.label" default="State" /></span>
					
					<span class="property-value" aria-labelledby="state-label"><g:fieldValue bean="${quizzInstance}" field="state"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${quizzInstance?.answers}">
				<li class="fieldcontain">
					<span id="answers-label" class="property-label">Pending Answers</span>
					
						<g:each in="${quizzInstance.answers}" var="a">
						<g:if test="${a.status == Answer.STATUS_PENDING}">
							<span class="property-value" aria-labelledby="answers-label"><g:link controller="answer" action="show" id="${a.id}">#${a?.id}: ${a?.answer} - ${a?.validity}</g:link></span>
						</g:if>						
						</g:each>
					
				</li>
				
				<li class="fieldcontain">
					<span id="answers-label" class="property-label">Approved Answers</span>
					
						<g:each in="${quizzInstance.answers}" var="a">
						<g:if test="${a?.status == Answer.STATUS_APPROVED}">
							<span class="property-value" aria-labelledby="answers-label"><g:link controller="answer" action="show" id="${a?.id}">#${a?.id}: ${a?.answer} - ${a?.validity}</g:link></span>
						</g:if>						
						</g:each>
					
				</li>
				
				<li class="fieldcontain">
					<span id="answers-label" class="property-label">Rejected Answers</span>
					
						<g:each in="${quizzInstance.answers}" var="a">
						<g:if test="${a?.status == Answer.STATUS_REJECTED}">
							<span class="property-value" aria-labelledby="answers-label"><g:link controller="answer" action="show" id="${a?.id}">#${a?.id}: ${a?.answer} - ${a?.validity}</g:link></span>
						</g:if>						
						</g:each>
					
				</li>
				</g:if>
			
			</ol>
			<g:form>
				<fieldset class="buttons">
					<g:hiddenField name="id" value="${quizzInstance?.id}" />
					<shiro:hasRole name="ROLE_TEACHER">
						<g:link class="edit" action="edit" id="${quizzInstance?.id}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
						<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
					</shiro:hasRole>
					<!--  Quizz à l'état OUVERT -->
					<g:if test="${quizzInstance.state == Quizz.STATE_OPENED}">
						<g:link class="attach" controller="answer" action="create" params="['quizz.id': quizzInstance?.id]"><g:message code="default.button.add.label" default="Add Answer" /></g:link>
						<shiro:hasRole name="ROLE_TEACHER"><g:link action="startVote" id="${quizzInstance?.id}"><g:message code="default.button.show.label" default="Start Vote" /></g:link></shiro:hasRole>
					</g:if>		
					
					<!--  Quizz à l'état VOTE -->
					<g:if test="${quizzInstance.state == Quizz.STATE_VOTING}">
						<g:link class="show" action="vote" id="${quizzInstance?.id}"><g:message code="default.button.show.label" default="View Vote" /></g:link>
						<shiro:hasRole name="ROLE_TEACHER">
							<g:link action="endVote" id="${quizzInstance?.id}"><g:message code="default.button.show.label" default="End Vote" /></g:link>
						<g:link action="resetVotes" id="${quizzInstance?.id}" onclick="return confirm('Do you really want to reset all the votes?');"><g:message code="default.button.show.label" default="Reset Votes" /></g:link>	
						</shiro:hasRole>		
					</g:if>	
				
					<!--  Quizz à l'état CLOSE -->
					<g:if test="${quizzInstance.state == Quizz.STATE_CLOSED}">
						<g:link action="showStats" id="${quizzInstance?.id}"><g:message code="default.button.show.label" default="Show Stats" /></g:link>
					</g:if>
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
