<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/">
    <html>
      <head>
        <meta charset="utf-8"/>
        <title>Weather forecast</title>
        <style>
          /* Container limits how wide the table becomes on large screens */
          .container { max-width: 980px; margin: 18px auto; padding: 6px; }

          /* Table uses full width of container but table-layout:fixed keeps column widths stable */
          table.forecast { border-collapse: collapse; width: 100%; table-layout: fixed; }
          table.forecast th, table.forecast td { border: 1px solid #999; padding: 8px; text-align: center; vertical-align: top; }

          /* Header row and first column yellow */
          table.forecast thead th { font-weight: bold; background: #f2a800; }
          .first-col { background: #f2a800; }

          /* Fix first column width and let the other 7 columns share the remaining space */
          .first-col { width: 120px; }
          table.forecast th:nth-child(n+2), table.forecast td:nth-child(n+2) { width: calc((100% - 120px) / 7); }

          /* Make each cell reasonably tall so icons and text match the example */
          table.forecast td { min-height: 120px; height: 120px; }

          /* Image styling */
          .cell img { display:block; margin: 6px auto; max-width: 58px; height: auto; }

          .desc { font-size: 0.95em; margin-top:6px; }
          .temp { font-weight: bold; margin-top:6px; color: #333; }

          /* Colouring for different weather types similar to example */
          .cloudy .desc { color: green; }
          .rain .desc, .thunderstorm .desc { color: blue; }
          .partlySunny .desc { color: red; }
          .sunny .desc { color: #ff7f00; }

          /* Small responsive tweak: if screen is narrow, allow scrolling */
          @media (max-width: 620px) {
            .container { padding: 4px; }
            table.forecast th:nth-child(n+2), table.forecast td:nth-child(n+2) { width: auto; }
            table.forecast { display: block; overflow-x: auto; white-space: nowrap; }
            table.forecast td { min-height: 100px; }
          }
        </style>
      </head>
      <body>
        <h3>
          <xsl:value-of select="concat(forecast/@queryLocation, ' [', forecast/@queryTime, ']')"/>
        </h3>

        <div class="container">
          <table class="forecast">
            <thead>
              <tr>
                <th class="first-col">Date</th>
                <th>Mon</th>
                <th>Tues</th>
                <th>Wed</th>
                <th>Thur</th>
                <th>Fri</th>
                <th>Sat</th>
                <th>Sun</th>
              </tr>
            </thead>
            <tbody>
              <xsl:for-each select="forecast/weather">
                <xsl:sort select="@yyyymmdd" order="descending" data-type="text"/>

                <xsl:variable name="imgExt">
                  <xsl:choose>
                    <xsl:when test="overallCode='cloudy' or overallCode='partlySunny' or overallCode='sunny'">.jpeg</xsl:when>
                    <xsl:otherwise>.png</xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>

                <tr>
                  <td class="first-col">
                    <xsl:value-of select="concat(date, ' ', 
                      substring('Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec', (number(month) - 1) * 4 + 1, 3))"/>
                  </td>

                  <!-- Helper for rendering a weekday cell with class set to overallCode -->
                  <xsl:for-each select="('Mon','Tues','Wed','Thur','Fri','Sat','Sun')">
                    <xsl:variable name="wd" select="."/>
                    <td>
                      <xsl:if test="dayOfWeek = $wd">
                        <div>
                          <xsl:attribute name="class">
                            <xsl:value-of select="concat('cell ', overallCode)"/>
                          </xsl:attribute>
                          <img>
                            <xsl:attribute name="src">
                              <xsl:value-of select="concat('A2_Resources/', overallCode, $imgExt)"/>
                            </xsl:attribute>
                            <xsl:attribute name="alt">
                              <xsl:value-of select="overall"/>
                            </xsl:attribute>
                          </img>
                          <div class="desc"><xsl:value-of select="overall"/></div>
                          <div class="temp"><xsl:value-of select="concat(lowest, '&#176; - ', highest, '&#176;')"/></div>
                        </div>
                      </xsl:if>
                    </td>
                  </xsl:for-each>

                </tr>
              </xsl:for-each>
            </tbody>
          </table>
        </div>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>