<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="base"/>

<xsl:template match="/">

<xsl:choose>
<xsl:when test="session/@error=0">
	Top 100 of <xsl:value-of select="session/@items"/> items (based on <xsl:value-of select="session/@votes"/> votes from <xsl:value-of select="session/@voters"/> voters).

	<ul id="filter" data-role="listview" data-filter="true" data-inset="true" data-filter-placeholder="Search content...">
	<xsl:for-each select="session/item">
		<li style="white-space: normal"><p><xsl:value-of select="position()" />. Confidence Score: <xsl:value-of select="@score"/></p><xsl:value-of select="."/></li>
	</xsl:for-each>
	</ul>
	<script type="text/javascript">
		$('#read_title').html('<xsl:value-of select="session/@title"/>').trigger( "updatelayout" );
	</script>	
</xsl:when>
<xsl:otherwise>
	<h2>There was an error.</h2>
	<p><xsl:value-of select="session/@msg"/></p>	
	<input type="button" value="Reload" onClick="window.top.location.reload();"/>
</xsl:otherwise>
</xsl:choose>

</xsl:template>

</xsl:stylesheet>