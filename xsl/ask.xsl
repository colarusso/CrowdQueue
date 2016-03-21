<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="base"/>

<xsl:template match="/">

<xsl:choose>
<xsl:when test="session/@error=0">
	<xsl:choose>
	<xsl:when test="session/@status=0">
		You have joined <em><xsl:value-of select="."/></em>. Once this session starts accepting submissions, you can hit the reload button to submit and vote on <xsl:value-of select="session/@type"/>s.
		<p>
		<input type="button" value="Reload" onClick="loadme('ask','','','{session/@page}');"/>
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
		<em><xsl:value-of select="."/></em> has closed. To see the final results press the button below.
		<input type="button" value="See Results" onClick="loadme('read');"/>
	</xsl:when>
	<xsl:otherwise>
		<xsl:choose> 
		<xsl:when test="session/@myitems &lt;= session/@maxitems">
		Write your <xsl:value-of select="session/@type"/> in the space below. This is <xsl:value-of select="session/@myitems"/> of <xsl:value-of select="session/@maxitems"/>&#160;<xsl:value-of select="session/@type"/>(s) you are allowed to submit. Make it count. Characters remaining: <span id="remaining"><xsl:value-of select="session/@length"/></span>.
		<textarea id="{session/@uid}" style="height:200px;" maxlength="{session/@length}"></textarea>
		<p>
		<input type="button" value="Submit" onClick="item_text=$('#{session/@uid}').val();loadme('ask','','','{session/@page}');"/>
		</p><p>
		<input type="button" value="Clear" onClick="$('#{session/@uid}').val('');"/>
		</p>
		<hr/>
		<p>
		To vote on <xsl:value-of select="session/@type"/>s, click the "Vote" tab at the top of this screen. Note: when you submit a <xsl:value-of select="session/@type"/>, we automatically vote it up on your behalf.
		</p>
		</xsl:when>
		<xsl:otherwise>
		
			You have reached your limit. Participants are only allowed to submit <xsl:value-of select="session/@maxitems"/>&#160;<xsl:value-of select="session/@type"/>(s). Once this session is closed, you can hit the reload button to see a ranked list of <xsl:value-of select="session/@type"/>s. Until then, if you haven't already, consider voting at the "Vote" tab above. 
			<input type="button" value="Reload" onClick="loadme('ask','','','{session/@page}');"/>
	 
		</xsl:otherwise>
		</xsl:choose>
	</xsl:otherwise>
	</xsl:choose>
	<script type="text/javascript">
		$('#ask_title').html('<xsl:value-of select="."/>').trigger( "updatelayout" );
		$('#ask_n_title').html('<xsl:value-of select="."/>').trigger( "updatelayout" );
		mysessions.length = 0;
		mysessionsStats.length = 0;
		<xsl:for-each select="session[@author='1']">
		mysessions.push("<xsl:value-of select="@code"/>");
		mysessionsStats.push("<xsl:value-of select="@status"/>");
		</xsl:for-each>
		sessionStat_code.length = 0;
		sessionStat.length = 0;
		<xsl:for-each select="session">
		sessionStat_code.push("<xsl:value-of select="@code"/>");
		sessionStat.push("<xsl:value-of select="@status"/>");
		</xsl:for-each>
		if (RUauthor(code)) {
			$( ".close" ).show();
		}
		$(document).ready(function() {
			var text_max = <xsl:value-of select="session/@length"/>;
			$('#remaining').html(text_max);

			$('#<xsl:value-of select="session/@uid"/>').keyup(function() {
				var text_length = $('#<xsl:value-of select="session/@uid"/>').val().length;
				var text_remaining = text_max - text_length;

				$('#remaining').html(text_remaining);
			});
		});
	</script>	
</xsl:when>
<xsl:otherwise>
	<p><xsl:value-of select="session/@msg"/></p>	
	<input type="button" value="Try Again" onClick="window.top.location.reload();"/>
</xsl:otherwise>
</xsl:choose>

</xsl:template>

</xsl:stylesheet>