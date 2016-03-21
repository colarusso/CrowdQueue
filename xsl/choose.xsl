<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="base"/>

<xsl:template match="/">

<xsl:choose>
<xsl:when test="sessions/@error=0">

	Enter a session code and check-in. 
	<input id="sessioncode" type="text" value="" maxlength="200"/>
	<input type="button" value="Check-In" onClick="checkIn(document.getElementById('sessioncode').value);"/>
	<p style="text-align:center;color:#555">
	<em>~ OR ~</em>
	</p>
	<input type="button" value="Create A New Session" onClick="loadme('make');"/>
	
	<xsl:choose> 
		<xsl:when test="count(sessions/session) > 0">
			<p style="text-align:center;color:#555">
			<em>~ OR ~</em>
			</p>
			Revisit session(s) form the past 48 hours.
			<ul id="filter" data-role="listview" data-filter="true" data-inset="true" data-filter-placeholder="Filter titles and codes...">
				<xsl:for-each select="sessions/session">
					<li><a href="#" onClick="code='{@code}';loadme('ask');"> <xsl:value-of select="."/><p><xsl:value-of select="@code"/></p></a></li>
				</xsl:for-each>
			</ul>
			<p style="text-align:center;"><a href="#about" data-direction="reverse">about</a></p>
		</xsl:when>
		<xsl:otherwise>
			<div style="float:left;background:#5489eb;border-radius:15px;padding:10px 15px 14px 15px;color:#fff;text-shadow: none;box-shadow: none;-webkit-box-shadow: none;margin-top:20px;">
				Crowd Queue helps gatherings discover attendees' best questions/ideas. <a href="#about" style="color:white;" data-direction="reverse">Learn more</a>.
			</div>
			<div style="float:left;width:100%;"><div style="float:left;width:0;height:0;border-left:5px solid transparent;border-right:10px solid transparent;border-top:15px solid #5489eb;margin:0 20px;"></div>
			</div><div style="float:left;width:100%;line-height:40px;margin:5px 0 10px 5px;"><img src="https://pbs.twimg.com/profile_images/497171051793502208/ygwsLgxO.jpeg" style="width:40px;height:40px;border-radius:50%;" align="left"/>&#160;&#160;<a href="https://twitter.com/Colarusso" target="_blank">@Colarusso</a></div>
		</xsl:otherwise>
	</xsl:choose>	
</xsl:when>
<xsl:otherwise>
	<h2>There was an error.</h2>
	<p><xsl:value-of select="sessions/@msg"/></p>	
</xsl:otherwise>
</xsl:choose>

<script type="text/javascript">
	mysessions.length = 0;
	mysessionsStats.length = 0;
	<xsl:for-each select="sessions/session[@author='1']">
	mysessions.push("<xsl:value-of select="@code"/>");
	mysessionsStats.push("<xsl:value-of select="@status"/>");
	</xsl:for-each>
	sessionStat_code.length = 0;
	sessionStat.length = 0;
	<xsl:for-each select="sessions/session">
	sessionStat_code.push("<xsl:value-of select="@code"/>");
	sessionStat.push("<xsl:value-of select="@status"/>");
	</xsl:for-each>
</script>

</xsl:template>

</xsl:stylesheet>