<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="base"/>

<xsl:template match="/">

<xsl:choose>
<xsl:when test="session/@error=0">
	<xsl:choose>
	<xsl:when test="session/@status=0">
		You have joined <em><xsl:value-of select="session/@title"/></em>. Once this session starts accepting submissions, you can hit the reload button to submit and vote on <xsl:value-of select="session/@type"/>s.
		<p>
		<input type="button" value="Reload" onClick="loadme('vote','','','{session/@page}');"/>
		</p>
		<p>
		Note: sessions contain three stages.<sup>&#8224;</sup>
		</p>
		<p><em>1. Check-In:</em> users check-in with the session code. Users cannot submit or vote on content during this stage.</p>
		<p><em>2. Open Submissions &amp; Voting:</em> anyone who has checked in can submit content and vote on their peers' submissions. New users are not allowed to check-in during this stage.</p>
		<p><em>3. Viewing Results:</em> voting ceases, and content is ranked. Anyone with the session code can view the final ranked ordering.</p>
		<p><sup>&#8224;</sup> All sessions expire 48 hours after their creation.</p>
	</xsl:when>
	<xsl:when test="session/@status=2">
		<em><xsl:value-of select="session/@title"/></em> has closed. To see the final results press the button below. 
		<input type="button" value="See Results" onClick="loadme('read');"/>
	</xsl:when>
	<xsl:when test="session/@items=0">
	There are no questions to vote on. Wait a moment, and hit the reload button. 
	<input type="button" value="Reload" onClick="loadme('vote','','','{session/@page}');"/>
	</xsl:when>
	<xsl:when test="session/@seen &gt; session/@items">
	You've seen all <xsl:value-of select="session/@items"/>&#160;<xsl:value-of select="session/@type"/>s, but they are still coming in. Wait a moment, and hit the reload button.
	<input type="button" value="Reload" onClick="loadme('vote','','','{session/@page}');"/>
	</xsl:when>
	<xsl:otherwise>
		Vote on whether or not you think this <xsl:value-of select="session/@type"/> should get attention. This is <xsl:value-of select="session/@seen"/> of <xsl:value-of select="session/@items"/>&#160;<xsl:value-of select="session/@type"/>s from <xsl:value-of select="session/@voters"/> participants.	
		<hr/> 
		<p><font size="+1">
		<xsl:value-of select="."/>
		</font></p>
		<script type="text/javascript">
			item_id = <xsl:value-of select="session/@qid"/>; 
		</script>	
	</xsl:otherwise>
	</xsl:choose>
	<script type="text/javascript">
		$('#vote_title').html('<xsl:value-of select="session/@title"/>').trigger( "updatelayout" );
		$('#vote_n_title').html('<xsl:value-of select="session/@title"/>').trigger( "updatelayout" );
	</script>	
</xsl:when>
<xsl:otherwise>
	<p><xsl:value-of select="session/@msg"/></p>	
	<input type="button" value="Try Again" onClick="window.top.location.reload();"/>
</xsl:otherwise>
</xsl:choose>

</xsl:template>

</xsl:stylesheet>