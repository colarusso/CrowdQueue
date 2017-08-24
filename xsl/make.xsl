<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="base"/>

<xsl:template match="/">

<xsl:choose>
<xsl:when test="session/@error=0">

	<xsl:choose>
	<xsl:when test="session/@status=-1">
		Enter a session title.<sup>&#8224;</sup>

		<input id="sessiontitle" type="text" value=""/>
		
		What type of content do you want to surface?
		<fieldset data-role="controlgroup">
			<label><input type="radio" name="type" id="type-1" value="question" onClick="change_text(this.value);" checked="checked"/>Questions</label>
			<label><input type="radio" name="type" id="type-2" value="idea" onClick="change_text(this.value);"/>Ideas</label>
			<label><input type="radio" name="type" id="type-3" value="comment" onClick="change_text(this.value);"/>Comments</label>
		</fieldset>
		<label for="slider-1">Max <span id="type_text_1">question</span> length (up to 5 min.):<sup>&#8224;&#8224;</sup></label>
	<input type="range" name="slider-1" id="slider-1" value="0.5" min="0.5" max="5" step="0.5" />

		<label for="slider-2">Max <span id="type_text_2">question</span>s per person (up to 10):</label>
	<input type="range" name="slider-2" id="slider-2" value="3" min="1" max="10" step="1" />

		<p>
		<input type="button" data-theme="b" value="Create Session" onClick="loadme('make','','','2');"/>
		</p>
		<p>
		<sup>&#8224;</sup> No special characters: letters, numbers, and spaces only.  
		</p>
		<p>
		<sup>&#8224;&#8224;</sup> Assumes roughly 180 words per minute and 5 letters per word.
		</p>
		<script type="text/javascript">
			$('#make_title').html('Create New').trigger( "updatelayout" );
			$('#make_n_title').html('Create New').trigger( "updatelayout" );
		</script>	
	</xsl:when>
	<xsl:when test="session/@status=0">
		Your session, <em><xsl:value-of select="."/></em>, has been created. To check-in, participants must visit <em>CrowdQueue.org</em> and enter the session code <em>before you start accepting submissions</em>:
		
		<p style="text-align:center;"><font size="+3"><b><xsl:value-of select="session/@code"/></b></font></p> 
		<p>
		Note: Sessions contain three stages.<sup>&#8224;</sup>
		</p>
		<p><em>1. Check-In:</em> users check-in with the session code. Users cannot submit or vote on content during this stage.</p>
		<p><em>2. Open Submissions &amp; Voting:</em> anyone who has checked in can submit content and vote on their peers' submissions. New users are not allowed to check-in during this stage.</p>
		<p><em>3. Viewing Results:</em> voting ceases, and content is ranked. Anyone with the session code can view the final ranked ordering.</p>	
		<p>
		You have been checked-in as its author. Give the above code to would-be participants with plenty of heads up. 
		</p>
		<p>
		<b>Once you start accepting submissions the session will not allow any new check-ins</b>, and only those users who have checked in will be allowed to contribute and vote.
		</p>
		<p>
		After clicking the button below, you will be given the option to contribute and vote just like any other participant. 
		</p>
		<p>
		<b>The session will end when the author (that's you) clicks the <img src="style/images/check.png" height="18px;" valign="middle;"/> (checkmark) button, found at the tops of the session's submission and voting screens.</b> After this button is pressed, the session will stop accepting new input, and all participants, including you, will be shown an ordered list of the top 100 submissions. 
		</p>

		<p>You and your session's participants may leave <em>CrowdQueue.org</em> and return to this session by entering the above code for 90 days after its creation, as long as you/they do not clear your/their browser's cookies.</p><p>Unless you want to close check-in do NOT click the button below. You can come back later and pick up where you left off. Note: you must vote with the same browser you used to check-in. See the <a href="#about" data-direction="reverse">about page</a> for more details.</p>
		
		<p>
		<input type="button" data-theme="b" style="white-space:normal;" value="Close Check-in / Accept Submissions" onClick="code='{session/@code}';session_status=1;loadme('ask');"/>
</p>	
				<p><sup>&#8224;</sup> All sessions expire 90 days after their creation.</p>

		
		<script type="text/javascript">
			$('#make_title').html('<xsl:value-of select="."/>').trigger( "updatelayout" );
			$('#make_n_title').html('<xsl:value-of select="."/>').trigger( "updatelayout" );
		</script>	
	</xsl:when>
	</xsl:choose>
	
</xsl:when>
<xsl:otherwise>
	<h2>There was an error.</h2>
	<p><xsl:value-of select="session/@msg"/></p>	
	<input type="button" value="Reload" onClick="window.top.location.reload();"/>
</xsl:otherwise>
</xsl:choose>

</xsl:template>

</xsl:stylesheet>