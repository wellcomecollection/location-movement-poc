<?xml version="1.0" encoding="iso-8859-1"?>

<!-- This stylesheet generates OAI records from CALM xml output - metadataprefix = marcxml -->
<!-- Created by David Little July 2003 -->
<!-- Last amended by JB May 16 -->
<!-- LS edit to language fields 11/10/19 -->
<!-- v 155 edited to enrich NIMR collection mapping-->
<!-- LS  new change to add subfield b to 949 250524-->
<!-- LS added Current Location field to item record 030724 -->
<!-- LS mapped box field to append to end of CUrrent Location field 12/12/24-->
<!-- LS decoupled opacmessage from access status.  Ordering_status now maps to opacmsg and Accessstatus maps to status. 10/11/25-->

<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" omit-xml-declaration="yes" indent="yes" />

	<xsl:template match="DScribeRecord">

	<record xmlns="http://www.loc.gov/MARC21/slim" xmlns:xsi="http://www.w3.org/2000/XMLSchema-instance"  type="Bibliographic">
	<xsl:comment>Testing</xsl:comment>
	
	<!-- All re-done by JB to make level change biblevel. + -->
			<leader>
				<xsl:text>00000n</xsl:text>
				<xsl:choose>
				<!-- version 61 Material replaced Format to define Leader position 6. More MATTYPES will have to be contemplated in the future eg betamax. This is not a priority-->	
					<xsl:when test="contains(//Material, 'Sound only')">
						<xsl:text>i</xsl:text>
					</xsl:when>
					<xsl:when test="starts-with(//Material, 'Audio-Visual Material - Visual')">
						<xsl:text>g</xsl:text>
					</xsl:when>
					<xsl:when test="starts-with(//Material, 'Audio-Visual Material - e-sound only')">
						<xsl:text>i</xsl:text>
					</xsl:when>
					<xsl:when test="starts-with(//Material, 'Audio-Visual Material - e-visual only')">
						<xsl:text>g</xsl:text>
					</xsl:when>
					<xsl:when test="starts-with(//Material, 'Archives - Digital')">
						<xsl:text>t</xsl:text>
					</xsl:when>
					<xsl:when test="starts-with(//Material, 'Published Material')">
						<xsl:text>a</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>t</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="starts-with(//RepositoryCode, '0120')">
							<xsl:call-template name="webdisplay"/>
					</xsl:when>
					<xsl:otherwise>e</xsl:otherwise>
				</xsl:choose>
				<xsl:text>aa2200145</xsl:text>
					<xsl:choose>
						<xsl:when test="starts-with(//CatalogueStatus, 'Not')">
							<xsl:text>5</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>u</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:text>u 4500</xsl:text>
			</leader>
				
						
				<controlfield tag="001" ind1="" ind2="">
					<subfield code="a"><xsl:value-of select="//AltRefNo"/></subfield>
				</controlfield>
				<!-- JB 006 field-->
		
		<xsl:choose>
			<xsl:when test="contains(//Material, 'Born')">
				<controlfield tag="006" ind1="" ind2="">
					<subfield code="a"><xsl:text>m   d</xsl:text></subfield>
				</controlfield>
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="contains(//Material, 'Hybrid')">
				<controlfield tag="006" ind1="" ind2="">
					<subfield code="a"><xsl:text>m   d</xsl:text></subfield>
				</controlfield>
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="starts-with(//Material, 'Audio-Visual Material - e-sound only')">
				<controlfield tag="006" ind1="" ind2="">
					<subfield code="a"><xsl:text>m   h</xsl:text></subfield>
				</controlfield>
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="starts-with(//Material, 'Audio-Visual Material - e-visual only')">
				<controlfield tag="006" ind1="" ind2="">
					<subfield code="a"><xsl:text>m   c</xsl:text></subfield>
				</controlfield>
			</xsl:when>
		</xsl:choose>
				<!--JB 007 field-->
		<xsl:choose>
			<xsl:when test="contains(//Material, 'Born')">
				<controlfield tag="007" ind1="" ind2="">
					<xsl:text>cr</xsl:text>
				</controlfield>
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="contains(//Material, 'Hybrid')">
				<controlfield tag="007" ind1="" ind2="">
					<xsl:text>cr</xsl:text>
				</controlfield>
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="contains(//Material, 'Sound only')">
				<controlfield tag="007" ind1="" ind2="">
						<xsl:text>s |||||||||||</xsl:text>
				</controlfield>
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="starts-with(//Material, 'Audio-Visual Material - e-sound only')">
				<controlfield tag="007" ind1="" ind2="">
					<xsl:text>cr|nna|||||||</xsl:text>
				</controlfield>
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="starts-with(//Material, 'Archives - Digital')">
				<controlfield tag="007" ind1="" ind2="">
					<xsl:text>cr ||||||||||</xsl:text>
				</controlfield>
			</xsl:when>
		</xsl:choose>
		
		<!--add condition so only items get this field-->
		<xsl:choose>
			<xsl:when test="starts-with(//Material, 'Audio-Visual Material - Visual')">
				<xsl:if test="starts-with(Level, 'Item')">
				<controlfield tag="007" ind1="" ind2="">					
					<xsl:call-template name="CodedAV"/>							
				</controlfield>	
				</xsl:if>	
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="starts-with(//Material, 'Audio-Visual Material - e-visual only')">
				<controlfield tag="007" ind1="" ind2="">
					<xsl:text>cr|una|||||||</xsl:text>
				</controlfield>
			</xsl:when>
		</xsl:choose>
				<!-- Code to create 008 field -->
				
				<controlfield tag="008" ind1="" ind2="">
					
					<!--Sets the date from file: positions 0-5 -->
			<xsl:choose>
				<xsl:when test="//Created">
					<xsl:variable name="date" select="string-length(//Created)"/>
					<xsl:variable name="dd" select="//Created"/>
					<xsl:choose>
						<xsl:when test="$date = 9">
							<xsl:value-of select="substring($dd,8,2)"/>
							<xsl:value-of select="substring($dd,3,2)"/>
							<xsl:text>0</xsl:text>
							<xsl:value-of select="substring($dd,1,1)"/>
						</xsl:when>
						<xsl:when test="$date = 10">
							<xsl:value-of select="substring($dd,9,2)"/>
							<xsl:value-of select="substring($dd,4,2)"/>
							<xsl:value-of select="substring($dd,1,2)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="date2" select="string-length(//Modified)"/>
							<xsl:variable name="dd2" select="//Modified"/>
							<xsl:choose>
								<xsl:when test="$date2 = 9">
									<xsl:value-of select="substring($dd2,8,2)"/>
									<xsl:value-of select="substring($dd2,3,2)"/>
									<xsl:text>0</xsl:text>
									<xsl:value-of select="substring($dd2,1,1)"/>
								</xsl:when>
								<xsl:when test="$date2 = 10">
									<xsl:value-of select="substring($dd2,9,2)"/>
									<xsl:value-of select="substring($dd2,4,2)"/>
									<xsl:value-of select="substring($dd2,1,2)"/>
								</xsl:when>
							</xsl:choose>
						</xsl:otherwise>
						</xsl:choose>		
				</xsl:when>
			</xsl:choose>		
					
					<!-- Dates of file - positions 7-10: Dates from 260 -->
					<xsl:choose>
						<!--Test for existence of Date tag -->
						<xsl:when test="//Date">
							<!-- At present the following code will only work if the date is post 11th century onwards, i.e. 2 digit centuries -->
							<!-- for BC -->
							<xsl:choose>
								<xsl:when test="contains(//Date, 'century BC')">
									<xsl:text>b        </xsl:text>
								</xsl:when>
							</xsl:choose>

							<!-- changed in version 83 to cope with eg early 18th century - late 19th century-->
							<xsl:choose>
								<xsl:when test="starts-with(//Date, 'early')">
									<xsl:variable name="CNS" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:variable name="Fuzzy" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:variable name="MCen" select="string-length($Fuzzy)"/>
									<xsl:choose>
										<!-- string lenght sometimes needs ! when equal to zero -->
										<xsl:when test="$MCen =0">
											<xsl:call-template name="numerals"/>
										</xsl:when>
										<!-- same as early - early, second needs to keep "-" -->
										<xsl:when test="contains(//Date, '- early')">
											<xsl:call-template name="earlyearlystart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, 'mid')">
											<!--Changed these dates to templates and start using only string of numbers-->
											<xsl:call-template name="earlymidstart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, 'late')">
											<xsl:call-template name="earlylatestart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, '-1')">
											<xsl:call-template name="earlylatestart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, '- 1')">
											<xsl:call-template name="earlylatestart"/>
										</xsl:when>
										<xsl:when test="$MCen =2">
											<xsl:variable name="century" select="substring($CNS, 1, 2)"/>
											<xsl:variable name="years" select="$century - 1"/>
											<xsl:text>m</xsl:text>
											<xsl:value-of select="$years"/>
											<xsl:text>00</xsl:text>
											<xsl:variable name="Century" select="substring($CNS, 1, 2)"/>
											<xsl:variable name="Years" select="$Century - 1"/>
											<xsl:value-of select="$Years"/>
											<xsl:text>39</xsl:text>
										</xsl:when>
									</xsl:choose>
								</xsl:when>
								<xsl:when test="starts-with(//Date, 'Early')">
									<xsl:variable name="CNS" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:variable name="Fuzzy" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:variable name="MCen" select="string-length($Fuzzy)"/>
									<xsl:choose>
										<!-- string lenght needs ! when equal to zero -->
										<xsl:when test="$MCen =0">
											<xsl:call-template name="numerals"/>
										</xsl:when>	
										<xsl:when test="contains(//Date, 'early')">
											<xsl:call-template name="earlyearlystart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, '- Early')">
											<xsl:call-template name="earlyearlystart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, '-Early')">
											<xsl:call-template name="earlyearlystart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, 'mid')">
											<xsl:call-template name="earlymidstart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, 'Mid')">
											<xsl:call-template name="earlymidstart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, 'late')">
											<xsl:call-template name="earlylatestart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, 'Late')">
											<xsl:call-template name="earlylatestart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, '-1')">
											<xsl:call-template name="earlylatestart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, '- 1')">
											<xsl:call-template name="earlylatestart"/>
										</xsl:when>
										<xsl:when test="$MCen =2">
											<xsl:variable name="century" select="substring($CNS, 1, 2)"/>
											<xsl:variable name="years" select="$century - 1"/>
											<xsl:text>m</xsl:text>
											<xsl:value-of select="$years"/>
											<xsl:text>00</xsl:text>
											<xsl:variable name="Century" select="substring($CNS, 1, 2)"/>
											<xsl:variable name="Years" select="$Century - 1"/>
											<xsl:value-of select="$Years"/>
											<xsl:text>39</xsl:text>
										</xsl:when>
									</xsl:choose>
								</xsl:when>
								<!-- starts with Mid? Left Middle section in old version for comparison -->
								<xsl:when test="starts-with(//Date, 'Middle')">
									<xsl:choose>
										<xsl:when test="contains(//Date, '- early')">
											<xsl:variable name="century" select="substring(//Date, 8, 2)"/>
											<xsl:variable name="years" select="$century - 1"/>
											<xsl:text>m</xsl:text>
											<xsl:value-of select="$years"/>
											<xsl:text>30</xsl:text>
											<xsl:variable name="Century" select="substring(//Date, 29, 2)"/>
											<xsl:variable name="Years" select="$Century - 1"/>
											<xsl:value-of select="$Years"/>
											<xsl:text>00</xsl:text>
										</xsl:when>
										<xsl:when test="contains(//Date, '- Early')">
											<xsl:variable name="century" select="substring(//Date, 8, 2)"/>
											<xsl:variable name="years" select="$century - 1"/>
											<xsl:text>m</xsl:text>
											<xsl:value-of select="$years"/>
											<xsl:text>30</xsl:text>
											<xsl:variable name="Century" select="substring(//Date, 29, 2)"/>
											<xsl:variable name="Years" select="$Century - 1"/>
											<xsl:value-of select="$Years"/>
											<xsl:text>00</xsl:text>
										</xsl:when>
										<xsl:when test="contains(//Date, '- mid')">
											<xsl:variable name="century" select="substring(//Date, 8, 2)"/>
											<xsl:variable name="years" select="$century - 1"/>
											<xsl:text>m</xsl:text>
											<xsl:value-of select="$years"/>
											<xsl:text>30</xsl:text>
											<xsl:variable name="Century" select="substring(//Date, 27, 2)"/>
											<xsl:variable name="Years" select="$Century - 1"/>
											<xsl:value-of select="$Years"/>
											<xsl:text>69</xsl:text>
										</xsl:when>
										<xsl:when test="contains(//Date, '- Mid')">
											<xsl:variable name="century" select="substring(//Date, 8, 2)"/>
											<xsl:variable name="years" select="$century - 1"/>
											<xsl:text>m</xsl:text>
											<xsl:value-of select="$years"/>
											<xsl:text>30</xsl:text>
											<xsl:variable name="Century" select="substring(//Date, 27, 2)"/>
											<xsl:variable name="Years" select="$Century - 1"/>
											<xsl:value-of select="$Years"/>
											<xsl:text>69</xsl:text>
										</xsl:when>
										<xsl:when test="contains(//Date, '- late')">
											<xsl:variable name="century" select="substring(//Date, 8, 2)"/>
											<xsl:variable name="years" select="$century - 1"/>
											<xsl:text>m</xsl:text>
											<xsl:value-of select="$years"/>
											<xsl:text>30</xsl:text>
											<xsl:variable name="Century" select="substring(//Date, 28, 2)"/>
											<xsl:variable name="Years" select="$Century - 1"/>
											<xsl:value-of select="$Years"/>
											<xsl:text>99</xsl:text>
										</xsl:when>
										<xsl:when test="contains(//Date, '- Late')">
											<xsl:variable name="century" select="substring(//Date, 8, 2)"/>
											<xsl:variable name="years" select="$century - 1"/>
											<xsl:text>m</xsl:text>
											<xsl:value-of select="$years"/>
											<xsl:text>30</xsl:text>
											<xsl:variable name="Century" select="substring(//Date, 28, 2)"/>
											<xsl:variable name="Years" select="$Century - 1"/>
											<xsl:value-of select="$Years"/>
											<xsl:text>99</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:variable name="century" select="substring(//Date, 8, 2)"/>
											<xsl:variable name="years" select="$century - 1"/>
											<xsl:text>m</xsl:text>
											<xsl:value-of select="$years"/>
											<xsl:text>30</xsl:text>
											<xsl:value-of select="$years"/>
											<xsl:text>69</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:when test="starts-with(//Date, 'mid')">
									<xsl:variable name="CNS" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:variable name="Fuzzy" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:variable name="MCen" select="string-length($Fuzzy)"/>
									<xsl:choose>
										<!-- string length sometimes needs ! when equal to zero -->
										<xsl:when test="$MCen =0">
											<xsl:call-template name="numerals2"/>
										</xsl:when>
										<xsl:when test="contains(//Date, 'early')">
											<xsl:call-template name="midearlystart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, '- mid')">
											<xsl:call-template name="midmidstart"/>
										</xsl:when>	
										<xsl:when test="contains(//Date, 'late')">
											<xsl:call-template name="midlatestart"/>
										</xsl:when>
										<xsl:when test="$MCen =2">
											<xsl:variable name="century" select="substring($CNS, 1, 2)"/>
											<xsl:variable name="years" select="$century - 1"/>
											<xsl:text>m</xsl:text>
											<xsl:value-of select="$years"/>
											<xsl:text>30</xsl:text>
											<xsl:variable name="Century" select="substring($CNS, 1, 2)"/>
											<xsl:variable name="Years" select="$Century - 1"/>
											<xsl:value-of select="$Years"/>
											<xsl:text>69</xsl:text>
										</xsl:when>
									</xsl:choose>
								</xsl:when>
								
								<xsl:when test="starts-with(//Date, 'Mid')">
									<xsl:variable name="CNS" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:variable name="Fuzzy" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:variable name="MCen" select="string-length($Fuzzy)"/>
									<xsl:choose>
										<xsl:when test="$MCen =0">
											<xsl:call-template name="numerals2"/>
										</xsl:when>
										<xsl:when test="contains(//Date, 'early')">
											<xsl:call-template name="midearlystart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, 'Early')">
											<xsl:call-template name="midearlystart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, 'mid')">
											<xsl:call-template name="midmidstart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, '- Mid')">
											<xsl:call-template name="midmidstart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, 'late')">
											<xsl:call-template name="midlatestart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, 'Late')">
											<xsl:call-template name="midlatestart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, '-1')">
											<xsl:call-template name="midlatestart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, '- 1')">
											<xsl:call-template name="midlatestart"/>
										</xsl:when>
										<xsl:when test="$MCen =2">
											<xsl:variable name="century" select="substring($CNS, 1, 2)"/>
											<xsl:variable name="years" select="$century - 1"/>
											<xsl:text>m</xsl:text>
											<xsl:value-of select="$years"/>
											<xsl:text>30</xsl:text>
											<xsl:variable name="Century" select="substring($CNS, 1, 2)"/>
											<xsl:variable name="Years" select="$Century - 1"/>
											<xsl:value-of select="$Years"/>
											<xsl:text>69</xsl:text>
										</xsl:when>
									</xsl:choose>
								</xsl:when>
								<!-- starts with late? -->
								<xsl:when test="starts-with(//Date, 'late')">
									<xsl:variable name="CNS" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:variable name="Fuzzy" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:variable name="MCen" select="string-length($Fuzzy)"/>
									<xsl:choose>
										<xsl:when test="$MCen =0">
											<xsl:call-template name="numerals3"/>
										</xsl:when>
										<xsl:when test="contains(//Date, 'early')">
											<xsl:call-template name="lateearlystart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, 'mid')">
											<xsl:call-template name="latemidstart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, '- late')">
											<xsl:call-template name="latelatestart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, '-1')">
											<xsl:call-template name="latelatestart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, '- 1')">
											<xsl:call-template name="latelatestart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, '-2')">
											<xsl:call-template name="latelatestart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, '- 2')">
											<xsl:call-template name="latelatestart"/>
										</xsl:when>
										<xsl:when test="$MCen =2">
											<xsl:variable name="century" select="substring($CNS, 1, 2)"/>
											<xsl:variable name="years" select="$century - 1"/>
											<xsl:text>m</xsl:text>
											<xsl:value-of select="$years"/>
											<xsl:text>60</xsl:text>
											<xsl:variable name="Century" select="substring($CNS, 1, 2)"/>
											<xsl:variable name="Years" select="$Century - 1"/>
											<xsl:value-of select="$Years"/>
											<xsl:text>99</xsl:text>
										</xsl:when>
									</xsl:choose>
								</xsl:when>
								<xsl:when test="starts-with(//Date, 'Late')">
									<xsl:variable name="CNS" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:variable name="Fuzzy" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:variable name="MCen" select="string-length($Fuzzy)"/>
									<xsl:choose>
										<xsl:when test="$MCen =0">
											<xsl:call-template name="numerals3"/>
										</xsl:when>
										<xsl:when test="contains(//Date, 'Early')">
											<xsl:call-template name="lateearlystart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, 'early')">
											<xsl:call-template name="lateearlystart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, 'mid')">
											<xsl:call-template name="latemidstart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, 'Mid')">
											<xsl:call-template name="latemidstart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, 'late')">
											<xsl:call-template name="latelatestart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, '- Late')">
											<xsl:call-template name="latelatestart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, '-1')">
											<xsl:call-template name="latelatestart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, '- 1')">
											<xsl:call-template name="latelatestart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, '-2')">
											<xsl:call-template name="latelatestart"/>
										</xsl:when>
										<xsl:when test="contains(//Date, '- 2')">
											<xsl:call-template name="latelatestart"/>
										</xsl:when>
										<xsl:when test="$MCen =2">
											<xsl:variable name="century" select="substring($CNS, 1, 2)"/>
											<xsl:variable name="years" select="$century - 1"/>
											<xsl:text>m</xsl:text>
											<xsl:value-of select="$years"/>
											<xsl:text>60</xsl:text>
											<xsl:variable name="Century" select="substring($CNS, 1, 2)"/>
											<xsl:variable name="Years" select="$Century - 1"/>
											<xsl:value-of select="$Years"/>
											<xsl:text>99</xsl:text>
										</xsl:when>
									</xsl:choose>
								</xsl:when>
								
								<xsl:when test="starts-with(//Date, '2nd century - 21st century')">
									<xsl:text>m01002013</xsl:text>
								</xsl:when>
								<xsl:when test="starts-with(//Date, '3rd century')">
									<xsl:text>m02000299</xsl:text>
								</xsl:when>
								<xsl:when test="starts-with(//Date, '4th century')">
									<xsl:text>m03000399</xsl:text>
								</xsl:when>
								<xsl:when test="starts-with(//Date, '5th century')">
									<xsl:text>m04000499</xsl:text>
								</xsl:when>
								<xsl:when test="starts-with(//Date, '11th')">
									<xsl:text>m10001099</xsl:text>
								</xsl:when>
								<xsl:when test="starts-with(//Date, '12th')">
									<xsl:text>m11001199</xsl:text>
								</xsl:when>
								<xsl:when test="starts-with(//Date, '13th')">
									<xsl:text>m12001299</xsl:text>
								</xsl:when>
								<xsl:when test="starts-with(//Date, '14th')">
									<xsl:choose>
										<xsl:when test="starts-with(//Date, '14th century - 1980s')">
											<xsl:text>m13001989</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>m13001399</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:when test="starts-with(//Date, '15th')">
									<xsl:choose>
										<xsl:when test="starts-with(//Date, '15th century - 1980s')">
											<xsl:text>m14001989</xsl:text>
										</xsl:when>
										<xsl:when test="starts-with(//Date, '15th century - 1990s')">
											<xsl:text>m14001999</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>m14001499</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:when test="starts-with(//Date, '16th')">
									<xsl:choose>
										<xsl:when test="starts-with(//Date, '16th century - 1980s')">
											<xsl:text>m15001989</xsl:text>
										</xsl:when>
										<xsl:when test="starts-with(//Date, '16th century - 1990s')">
											<xsl:text>m15001999</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>m15001599</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:when test="starts-with(//Date, '17th')">
									<xsl:choose>
										<xsl:when test="starts-with(//Date, '17th century - 1980s')">
											<xsl:text>m16001989</xsl:text>
										</xsl:when>
										<xsl:when test="starts-with(//Date, '17th century - 1990s')">
											<xsl:text>m16001999</xsl:text>
										</xsl:when>
										<xsl:when test="starts-with(//Date, '17th century - 1886')">
											<xsl:text>m16001886</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>m16001699</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:when test="starts-with(//Date, '18th')">
									<xsl:text>m17001799</xsl:text>
								</xsl:when>
								<xsl:when test="starts-with(//Date, '19th')">
									<xsl:text>m18001899</xsl:text>
								</xsl:when>
								<xsl:when test="starts-with(//Date, '20th')">
									<xsl:text>m19001999</xsl:text>
								</xsl:when>
								<!--Test for dates type 01/01/2001 and 01/01/2001-01/01/2002, added v 84-->
								<xsl:when test="contains(//Date, '/')">
									<xsl:variable name="letterout" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:variable name="letterz" select="string-length($letterout)"/>
									<xsl:choose>
										<xsl:when test="$letterz = 8">
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($letterout,5,4)"/>
											<xsl:text>    </xsl:text>
										</xsl:when>
									</xsl:choose>									
									<xsl:choose>
										<xsl:when test="$letterz = 6">
										
											<xsl:variable name="countinginters" select="translate(//Date, translate(//Date, '0123456789/', ''), '')"/>
											<xsl:variable name="filter1" select="substring($countinginters,4,2)"/>
											<xsl:variable name="filter2" select="substring($countinginters,5,2)"/>
											<xsl:variable name="filter3" select="substring($countinginters,6,2)"/>
											<xsl:choose>
												<xsl:when test="starts-with($filter1, '/')">
													<xsl:text>s</xsl:text>
													<xsl:value-of select="substring($letterout,3,4)"/>	
													<xsl:text>    </xsl:text>
												</xsl:when>
												<xsl:when test="starts-with($filter2, '/')">
													<xsl:text>m</xsl:text>
													<xsl:value-of select="substring($letterout,1,4)"/>
													<xsl:value-of select="substring($letterout,1,2)"/>
													<xsl:value-of select="substring($letterout,5,2)"/>											
												</xsl:when>
												<xsl:when test="starts-with($filter3, '/')">
													<xsl:text>m</xsl:text>
													<xsl:value-of select="substring($letterout,2,4)"/>
													<xsl:value-of select="substring($letterout,2,3)"/>
													<xsl:value-of select="substring($letterout,6,1)"/>											
												</xsl:when>
											</xsl:choose>
										</xsl:when>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="$letterz = 4">
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($letterout,1,4)"/>
										</xsl:when>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="$letterz = 5">
											
											<xsl:variable name="countinginters" select="translate(//Date, translate(//Date, '0123456789/', ''), '')"/>
											<xsl:variable name="filter1" select="substring($countinginters,5,2)"/>
								
											<xsl:choose>
												<xsl:when test="starts-with($filter1, '/')">
													<xsl:text>m</xsl:text>
													<xsl:value-of select="substring($letterout,1,4)"/>	
													<xsl:value-of select="substring($letterout,1,3)"/>
													<xsl:value-of select="substring($letterout,5,1)"/>
												</xsl:when>
											</xsl:choose>
										</xsl:when>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="$letterz = 7">
											<xsl:variable name="countinginters" select="translate(//Date, translate(//Date, '0123456789/', ''), '')"/>
											<xsl:variable name="filter1" select="substring($countinginters,7,2)"/>
											<xsl:variable name="filter2" select="substring($countinginters,5,2)"/>
											<xsl:variable name="filter3" select="substring($countinginters,6,2)"/>
											<xsl:choose>
												<xsl:when test="starts-with($filter1, '/')">
													<xsl:text>m</xsl:text>
													<xsl:value-of select="substring($letterout,3,4)"/>	
													<xsl:value-of select="substring($letterout,3,3)"/>
													<xsl:value-of select="substring($letterout,7,1)"/>
												</xsl:when>
												<xsl:when test="starts-with($filter2, '/')">
													<xsl:text>s</xsl:text>
													<xsl:value-of select="substring($letterout,4,4)"/>	
													<xsl:text>    </xsl:text>
												</xsl:when>
												<xsl:when test="starts-with($filter3, '/')">
													<xsl:text>m</xsl:text>
													<xsl:value-of select="substring($letterout,2,4)"/>
													<xsl:value-of select="substring($letterout,2,2)"/>
													<xsl:value-of select="substring($letterout,6,2)"/>											
												</xsl:when>
											</xsl:choose>
										</xsl:when>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="$letterz = 14">
											<xsl:text>m</xsl:text>
											<xsl:value-of select="substring($letterout,4,4)"/>
											<xsl:value-of select="substring($letterout,11,4)"/>
										</xsl:when>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="$letterz = 15">
											<xsl:text>m</xsl:text>
											<xsl:variable name="countinginters" select="translate(//Date, translate(//Date, '0123456789/', ''), '')"/>
											<xsl:variable name="filter1" select="substring($countinginters,5,2)"/>
											<xsl:variable name="filter2" select="substring($countinginters,6,2)"/>
											<xsl:choose>
												<xsl:when test="starts-with($filter1, '/')">
													<xsl:value-of select="substring($letterout,4,4)"/>
													<xsl:value-of select="substring($letterout,12,4)"/>	
												</xsl:when>
												<xsl:when test="starts-with($filter2, '/')">
													<xsl:value-of select="substring($letterout,5,4)"/>	
													<xsl:value-of select="substring($letterout,12,4)"/>	
												</xsl:when>
											</xsl:choose>
										</xsl:when>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="$letterz = 16">
											<xsl:text>m</xsl:text>
											<xsl:value-of select="substring($letterout,5,4)"/>
											<xsl:value-of select="substring($letterout,13,4)"/>
										</xsl:when>
									</xsl:choose>
								</xsl:when>
								<!--Test for existence of multiple date (check for hyphen)Jb also gets ready of any month mentioned -->
								<xsl:when test="contains(//Date, '-')">
									<xsl:variable name="letterout" select="translate(//Date, translate(//Date, '0123456789/', ''), '')"/>
									<xsl:variable name="letterz" select="string-length($letterout)"/>
										<xsl:choose>
											<xsl:when test="$letterz = 8">
												<xsl:variable name="countinginters" select="translate(//Date, translate(//Date, '0123456789-', ''), '')"/>
												<xsl:variable name="filter1" select="substring($countinginters,5,2)"/>
												<xsl:variable name="filter2" select="substring($countinginters,3,2)"/>
												<xsl:variable name="filter3" select="substring($countinginters,2,2)"/>
												<xsl:choose>
													<xsl:when test="starts-with($filter1, '-')">
														<xsl:text>m</xsl:text>
														<xsl:value-of select="substring($letterout,1,4)"/>
														<xsl:value-of select="substring($letterout,5,4)"/>											
													</xsl:when>
													<xsl:when test="starts-with($filter2, '-')">
														<xsl:text>s</xsl:text>
														<xsl:value-of select="substring($letterout,5,4)"/>
														<xsl:text>    </xsl:text>
													</xsl:when>
													<xsl:when test="starts-with($filter3, '-')">
														<xsl:text>s</xsl:text>
														<xsl:value-of select="substring($letterout,5,4)"/>
														<xsl:text>    </xsl:text>
													</xsl:when>
												</xsl:choose>
											</xsl:when>
										</xsl:choose>
									<xsl:choose>
										<xsl:when test="$letterz = 7">
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($letterout,4,4)"/>
											<xsl:text>    </xsl:text>
										</xsl:when>
									</xsl:choose>
									<!-- change made to version 118 to start checking if date starts on 1 or 2, to avoid having dates like 8841-->
									<xsl:choose>
										<xsl:when test="$letterz = 10">
											<xsl:text>m</xsl:text>
											<!-- this bit is done to look for stuff like 151879 - 1880; now i need to make it ready for 11879-11880-->
											<xsl:variable name="countinginters" select="translate(//Date, translate(//Date, '0123456789-', ''), '')"/>
											<xsl:variable name="filter1" select="substring($countinginters,7,2)"/>
											<xsl:variable name="filter2" select="substring($countinginters,6,2)"/>
											<xsl:variable name="filter3" select="substring($countinginters,5,2)"/>
											<xsl:variable name="filter4" select="substring($countinginters,9,2)"/>
											<xsl:variable name="filter5" select="substring($countinginters,4,2)"/>
											<xsl:choose>
												<xsl:when test="starts-with($filter1, '-')">
													
													<xsl:value-of select="substring($letterout,3,4)"/>
													<xsl:value-of select="substring($letterout,7,4)"/>
								
												</xsl:when>
												<xsl:when test="starts-with($filter2, '-')">
													 
													<xsl:value-of select="substring($letterout,2,4)"/>
													<xsl:value-of select="substring($letterout,7,4)"/>
														
												</xsl:when>
												<xsl:when test="starts-with($filter3, '-')">
						
													<xsl:value-of select="substring($letterout,1,4)"/>
													<xsl:value-of select="substring($letterout,7,4)"/>
														
												</xsl:when>
												<xsl:when test="starts-with($filter4, '-')">
													
													<xsl:value-of select="substring($letterout,1,4)"/>
													<xsl:value-of select="substring($letterout,5,2)"/>
													<xsl:value-of select="substring($letterout,9,2)"/>
													
												</xsl:when>
												<xsl:when test="starts-with($filter5, '-')">
													<xsl:value-of select="substring($letterout,7,4)"/>
													<xsl:value-of select="substring($letterout,7,4)"/>
												</xsl:when>
												<!-- end of bit-->
												
											</xsl:choose>
										</xsl:when>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="$letterz = 9">
											<xsl:text>m</xsl:text>
											<xsl:variable name="countinginters" select="translate(//Date, translate(//Date, '0123456789-', ''), '')"/>
											<xsl:variable name="filter1" select="substring($countinginters,6,2)"/>
											<xsl:variable name="filter2" select="substring($countinginters,5,2)"/>
											<xsl:variable name="filter3" select="substring($countinginters,9,2)"/>
											<xsl:choose>
												<xsl:when test="starts-with($filter1, '-')">
													<xsl:value-of select="substring($letterout,2,4)"/>
													<xsl:value-of select="substring($letterout,6,4)"/>											
												</xsl:when>
												<xsl:when test="starts-with($filter2, '-')">								
													<xsl:value-of select="substring($letterout,1,4)"/>
													<xsl:value-of select="substring($letterout,5,4)"/>											
												</xsl:when>
												<xsl:when test="starts-with($filter3, '-')">								
													<xsl:value-of select="substring($letterout,1,4)"/>
													<xsl:value-of select="substring($letterout,5,3)"/>	
													<xsl:value-of select="substring($letterout,9,1)"/>	
												</xsl:when>
											</xsl:choose>
										</xsl:when>
									</xsl:choose>
									
									<xsl:choose>
										<xsl:when test="$letterz = 11">
											<xsl:text>m</xsl:text>
											<xsl:variable name="countinginters" select="translate(//Date, translate(//Date, '0123456789-', ''), '')"/>
											<xsl:variable name="filter1" select="substring($countinginters,7,2)"/>
											<xsl:variable name="filter2" select="substring($countinginters,6,2)"/>
											<xsl:choose>
												<xsl:when test="starts-with($filter1, '-')">
													<xsl:value-of select="substring($letterout,3,4)"/>
													<xsl:value-of select="substring($letterout,8,4)"/>											
												</xsl:when>
												<xsl:when test="starts-with($filter2, '-')">								
													<xsl:value-of select="substring($letterout,2,4)"/>
													<xsl:value-of select="substring($letterout,8,4)"/>											
												</xsl:when>
											</xsl:choose>
										</xsl:when>
									</xsl:choose>
										<xsl:choose>
											<xsl:when test="$letterz = 12">
												<xsl:text>m</xsl:text>
												<xsl:variable name="countinginters" select="translate(//Date, translate(//Date, '0123456789-', ''), '')"/>
												<xsl:variable name="filter1" select="substring($countinginters,9,2)"/>
												<xsl:variable name="filter2" select="substring($countinginters,7,2)"/>
												<xsl:variable name="filter3" select="substring($countinginters,12,2)"/>
												<xsl:variable name="filter4" select="substring($countinginters,5,2)"/>
												<xsl:choose>
													<xsl:when test="starts-with($filter1, '-')">
														<xsl:value-of select="substring($letterout,1,4)"/>
														<xsl:value-of select="substring($letterout,9,4)"/>											
													</xsl:when>
													<xsl:when test="starts-with($filter2, '-')">								
														<xsl:value-of select="substring($letterout,3,4)"/>
														<xsl:value-of select="substring($letterout,9,4)"/>											
													</xsl:when>
													<xsl:when test="starts-with($filter3, '-')">								
														<xsl:value-of select="substring($letterout,1,4)"/>
														<xsl:value-of select="substring($letterout,7,2)"/>
														<xsl:value-of select="substring($letterout,11,2)"/>
													</xsl:when>
													<xsl:when test="starts-with($filter4, '-')">
														<xsl:value-of select="substring($letterout,1,4)"/>
														<xsl:value-of select="substring($letterout,9,4)"/>
													</xsl:when>
												</xsl:choose>
											</xsl:when>
										</xsl:choose>
									<xsl:choose>
										<xsl:when test="$letterz = 16">
											<xsl:text>m</xsl:text>
											<xsl:variable name="countinginters" select="translate(//Date, translate(//Date, '0123456789-', ''), '')"/>
											<xsl:variable name="filter1" select="substring($countinginters,9,2)"/>
											<xsl:variable name="filter2" select="substring($countinginters,5,2)"/>
											<xsl:variable name="filter3" select="substring($countinginters,13,2)"/>
											<xsl:variable name="filter4" select="substring($countinginters,11,2)"/>
											<xsl:choose>
												<xsl:when test="starts-with($filter1, '-')">
													<xsl:value-of select="substring($letterout,1,4)"/>
													<xsl:value-of select="substring($letterout,13,4)"/>											
												</xsl:when>
												<xsl:when test="starts-with($filter2, '-')">								
													<xsl:value-of select="substring($letterout,1,4)"/>
													<xsl:value-of select="substring($letterout,13,4)"/>											
												</xsl:when>
												<xsl:when test="starts-with($filter3, '-')">								
													<xsl:value-of select="substring($letterout,1,4)"/>
													<xsl:value-of select="substring($letterout,13,4)"/>
												</xsl:when>
												<xsl:when test="starts-with($filter4, '-')">								
													<xsl:value-of select="substring($letterout,1,4)"/>
													<xsl:value-of select="substring($letterout,13,4)"/>
												</xsl:when>
											</xsl:choose>
										</xsl:when>
									</xsl:choose>
										<xsl:choose>
											<xsl:when test="$letterz = 14">
												<xsl:text>m</xsl:text>
												<xsl:value-of select="substring($letterout,1,4)"/>
												<xsl:value-of select="substring($letterout,8,4)"/>
											</xsl:when>
										</xsl:choose>
									<xsl:choose>	
										<xsl:when test="$letterz = 6">
											<xsl:choose>
												<xsl:when test="starts-with(//Date, '1648-early 19th century')">
													<xsl:text>m16481839</xsl:text>
												</xsl:when>
											<xsl:otherwise>
												<xsl:variable name="countinginters" select="translate(//Date, translate(//Date, '0123456789-', ''), '')"/>
												<xsl:variable name="filter1" select="substring($countinginters,3,2)"/>
												<xsl:variable name="filter2" select="substring($countinginters,5,2)"/>
												<xsl:variable name="filter3" select="substring($countinginters,6,2)"/>
												<xsl:variable name="filter4" select="substring($countinginters,2,2)"/>
												<xsl:variable name="filter5" select="substring($countinginters,1,2)"/>
												<xsl:if test="starts-with($filter1, '-')">
													<xsl:text>s</xsl:text>
													<xsl:value-of select="substring($letterout,3,4)"/>
													<xsl:text>    </xsl:text>
												</xsl:if>
												<xsl:if test="starts-with($filter2, '-')">
													<xsl:text>m</xsl:text>
													<xsl:value-of select="substring($letterout,1,4)"/>
													<xsl:value-of select="substring($letterout,1,2)"/>
													<xsl:value-of select="substring($letterout,5,2)"/>
												</xsl:if>
												<xsl:if test="starts-with($filter3, '-')">
													<xsl:text>m</xsl:text>
													<xsl:value-of select="substring($letterout,2,4)"/>
													<xsl:value-of select="substring($letterout,2,3)"/>
													<xsl:value-of select="substring($letterout,6,1)"/>
												</xsl:if>
												<xsl:if test="starts-with($filter4, '-')">
													<xsl:text>s</xsl:text>
													<xsl:value-of select="substring($letterout,3,4)"/>
													<xsl:text>    </xsl:text>
												</xsl:if>
												<xsl:if test="starts-with($filter5, '-')">
													<xsl:text>s</xsl:text>
													<xsl:value-of select="substring($letterout,3,4)"/>
													<xsl:text>    </xsl:text>
												</xsl:if>
													</xsl:otherwise>	
													</xsl:choose>
										</xsl:when>
									</xsl:choose>
									<xsl:choose>	
										<xsl:when test="$letterz = 5">
											<xsl:variable name="countinginters" select="translate(//Date, translate(//Date, '0123456789-', ''), '')"/>
											<xsl:variable name="filter1" select="substring($countinginters,2,2)"/>
											<xsl:variable name="filter2" select="substring($countinginters,5,2)"/>
											<xsl:choose>
												<xsl:when test="starts-with($filter1, '-')">
													<xsl:text>s</xsl:text>
													<xsl:value-of select="substring($letterout,2,4)"/>
													<xsl:text>    </xsl:text>										
												</xsl:when>
												<xsl:when test="starts-with($filter2, '-')">	
													<xsl:text>m</xsl:text>
													<xsl:value-of select="substring($letterout,1,4)"/>
													<xsl:value-of select="substring($letterout,1,3)"/>	
													<xsl:value-of select="substring($letterout,5,1)"/>
												</xsl:when>
											</xsl:choose>
										</xsl:when>
									</xsl:choose>
										<xsl:choose>	
											<xsl:when test="$letterz = 4">
												<xsl:text>s</xsl:text>
												<xsl:value-of select="$letterout"/>
												<xsl:text>    </xsl:text>
											</xsl:when>
										</xsl:choose>
							<!-- JB deleted all c. references from here and created new one at end -->
								</xsl:when>
								<!-- Resolving () -->
								<xsl:when test="starts-with(//Date, '(')">
									<xsl:variable name="Circa" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:variable name="Curve" select="string-length($Circa)"/>
									<xsl:text>m</xsl:text>
									<xsl:choose>
										<xsl:when test="$Curve > 3">
											<xsl:value-of test="Circa" select="substring($Circa, 1, 4) - 5"/>
											<xsl:value-of test="Circa" select="substring($Circa, 1, 4) + 5"/>
										</xsl:when>
										<xsl:when test="$Curve = 2">
											<xsl:variable name="years" select="$Circa - 1"/>
											<xsl:value-of select="substring($years, 1, 2)"/>
											<xsl:text>00</xsl:text>
											<xsl:value-of select="substring($years, 1, 2)"/>
											<xsl:text>99</xsl:text>
										</xsl:when>
									</xsl:choose>
								</xsl:when>
								
								<!-- JB Resolving c., multiple dates +-10 -->
								<xsl:when test="starts-with(//Date, 'c')">
									<xsl:variable name="Circa" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:variable name="CC" select="string-length($Circa)"/>
									<xsl:choose>
									<xsl:when test="$CC = 4">
										<xsl:text>m</xsl:text>
										<xsl:value-of test="Circa" select="substring($Circa, 1, 4) - 10"/>
										<xsl:value-of test="Circa" select="substring($Circa, 1, 4) + 10"/>
									</xsl:when>	
										<xsl:when test="$CC = 3">
											<xsl:text>m0</xsl:text>
											<xsl:value-of test="Circa" select="substring($Circa, 1, 3) - 10"/>
											<xsl:text>0</xsl:text>
											<xsl:value-of test="Circa" select="substring($Circa, 1, 3) + 10"/>
										</xsl:when>		
									<xsl:when test="$CC = 2">
										<xsl:text>m</xsl:text>
										<xsl:value-of test="Circa" select="substring($Circa, 1, 2) - 2"/>
										<xsl:text>90</xsl:text>
										<xsl:value-of test="Circa" select="substring($Circa, 1, 2)"/>
										<xsl:text>10</xsl:text>
									</xsl:when>	
										<xsl:when test="$CC = 8">
											<xsl:text>m</xsl:text>
											<xsl:value-of test="Circa" select="substring($Circa, 1, 4) - 10"/>
											<xsl:value-of test="Circa" select="substring($Circa, 5, 4) + 10"/>
										</xsl:when>	
										<xsl:otherwise>
											<xsl:text>m</xsl:text>
											<xsl:value-of test="Circa" select="substring($Circa, 1, 4) - 10"/>
											<xsl:value-of test="Circa" select="substring($Circa, 1, 4) + 10"/>
										</xsl:otherwise>
									</xsl:choose>	
								</xsl:when>
								<xsl:when test="starts-with(//Date, '?c')">
									<xsl:variable name="Circa" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:text>m</xsl:text>
									<xsl:value-of test="Circa" select="substring($Circa, 1, 4) - 10"/>
									<xsl:value-of test="Circa" select="substring($Circa, 1, 4) + 10"/>
								</xsl:when>
								<xsl:when test="starts-with(//Date, '? c')">
									<xsl:variable name="Circa" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:text>m</xsl:text>
									<xsl:value-of test="Circa" select="substring($Circa, 1, 4) - 10"/>
									<xsl:value-of test="Circa" select="substring($Circa, 1, 4) + 10"/>
								</xsl:when>
								<xsl:when test="starts-with(//Date, 'C')">
									<xsl:variable name="Circa" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:variable name="CC" select="string-length($Circa)"/>
									<xsl:choose>
										<xsl:when test="$CC = 4">
											<xsl:text>m</xsl:text>
											<xsl:value-of test="Circa" select="substring($Circa, 1, 4) - 10"/>
											<xsl:value-of test="Circa" select="substring($Circa, 1, 4) + 10"/>
										</xsl:when>	
										<xsl:when test="$CC = 2">
											<xsl:text>m</xsl:text>
											<xsl:value-of test="Circa" select="substring($Circa, 1, 2) - 2"/>
											<xsl:text>90</xsl:text>
											<xsl:value-of test="Circa" select="substring($Circa, 1, 2)"/>
											<xsl:text>10</xsl:text>
										</xsl:when>	
									</xsl:choose>	
								</xsl:when>
								<!-- JB end of c. -->
								<!-- jb pre, post and after-->
								<xsl:when test="starts-with(//Date, 'Post')">
									<xsl:variable name="Post" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:text>m</xsl:text>
									<xsl:value-of test="Post" select="substring($Post, 1, 4) + 1"/>
									<xsl:value-of test="Post" select="substring($Post, 1, 4) + 10"/>
								</xsl:when>
								<xsl:when test="starts-with(//Date, 'post')">
									<xsl:variable name="Post" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:text>m</xsl:text>
									<xsl:value-of test="Post" select="substring($Post, 1, 4) + 1"/>
									<xsl:value-of test="Post" select="substring($Post, 1, 4) + 10"/>
								</xsl:when>
								<xsl:when test="starts-with(//Date, 'Pre')">
									<xsl:variable name="Post" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:text>m</xsl:text>
									<xsl:value-of test="Post" select="substring($Post, 1, 4) - 10"/>
									<xsl:value-of test="Post" select="substring($Post, 1, 4) - 1"/>
								</xsl:when>
								<xsl:when test="starts-with(//Date, 'pre')">
									<xsl:variable name="Post" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:text>m</xsl:text>
									<xsl:value-of test="Post" select="substring($Post, 1, 4) - 10"/>
									<xsl:value-of test="Post" select="substring($Post, 1, 4) - 1"/>
								</xsl:when>
								<xsl:when test="starts-with(//Date, 'Before')">
									<xsl:variable name="Post" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:text>m</xsl:text>
									<xsl:value-of test="Post" select="substring($Post, 1, 4) - 10"/>
									<xsl:value-of test="Post" select="substring($Post, 1, 4) - 1"/>
								</xsl:when>
								<!-- JB getting rid of months for single dates. Edited to accept any kind of abbreviation AND day numbers (v 82)! -->
								<xsl:when test="contains(//Date, 'Jan')">
									<xsl:variable name="Month" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:variable name="Months" select="string-length($Month)"/>
										<xsl:choose>
											<xsl:when test="$Months = 6">
												<xsl:text>s</xsl:text>
												<xsl:value-of select="substring($Month, 3, 4)"/>
												<xsl:text>    </xsl:text>
											</xsl:when>
											<xsl:when test="$Months = 5">
												<xsl:text>s</xsl:text>
												<xsl:value-of select="substring($Month, 2, 4)"/>
												<xsl:text>    </xsl:text>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>s</xsl:text>
												<xsl:value-of select="substring($Month, 1, 4)"/>
												<xsl:text>    </xsl:text>
											</xsl:otherwise>	
										</xsl:choose>	
								</xsl:when>
								
								<!--This version was replaced by above in version 76 so to allow month coming before or after number
								<xsl:when test="contains(//Date, 'Feb')">
									<xsl:variable name="Month" select="translate(//Date, 'Fabcdefghijklmnopqrstuvxyz. ', '!')"/>
									<xsl:text>s</xsl:text>
									<xsl:value-of select="substring-after($Month,'!')"/>
									<xsl:text>    </xsl:text>
								</xsl:when>-->
								
								<xsl:when test="contains(//Date, 'Feb')">
									<xsl:variable name="Month" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:variable name="Months" select="string-length($Month)"/>
									<xsl:choose>
										<xsl:when test="$Months = 6">
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($Month, 3, 4)"/>
											<xsl:text>    </xsl:text>
										</xsl:when>
										<xsl:when test="$Months = 5">
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($Month, 2, 4)"/>
											<xsl:text>    </xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($Month, 1, 4)"/>
											<xsl:text>    </xsl:text>
										</xsl:otherwise>	
									</xsl:choose>	
								</xsl:when>
		
								<xsl:when test="contains(//Date, 'Mar')">
									<xsl:variable name="Month" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:variable name="Months" select="string-length($Month)"/>
									<xsl:choose>
										<xsl:when test="$Months = 6">
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($Month, 3, 4)"/>
											<xsl:text>    </xsl:text>
										</xsl:when>
										<xsl:when test="$Months = 5">
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($Month, 2, 4)"/>
											<xsl:text>    </xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($Month, 1, 4)"/>
											<xsl:text>    </xsl:text>
										</xsl:otherwise>	
									</xsl:choose>	
								</xsl:when>
								
								<xsl:when test="contains(//Date, 'Apr')">
									<xsl:variable name="Month" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:variable name="Months" select="string-length($Month)"/>
									<xsl:choose>
										<xsl:when test="$Months = 6">
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($Month, 3, 4)"/>
											<xsl:text>    </xsl:text>
										</xsl:when>
										<xsl:when test="$Months = 5">
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($Month, 2, 4)"/>
											<xsl:text>    </xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($Month, 1, 4)"/>
											<xsl:text>    </xsl:text>
										</xsl:otherwise>	
									</xsl:choose>	
								</xsl:when>
								
								<xsl:when test="contains(//Date, 'May')">
									<xsl:variable name="Month" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:variable name="Months" select="string-length($Month)"/>
									<xsl:choose>
										<xsl:when test="$Months = 6">
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($Month, 3, 4)"/>
											<xsl:text>    </xsl:text>
										</xsl:when>
										<xsl:when test="$Months = 5">
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($Month, 2, 4)"/>
											<xsl:text>    </xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($Month, 1, 4)"/>
											<xsl:text>    </xsl:text>
										</xsl:otherwise>	
									</xsl:choose>	
								</xsl:when>
								
								<xsl:when test="contains(//Date, 'Jun')">
									<xsl:variable name="Month" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:variable name="Months" select="string-length($Month)"/>
									<xsl:choose>
										<xsl:when test="$Months = 6">
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($Month, 3, 4)"/>
											<xsl:text>    </xsl:text>
										</xsl:when>
										<xsl:when test="$Months = 5">
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($Month, 2, 4)"/>
											<xsl:text>    </xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($Month, 1, 4)"/>
											<xsl:text>    </xsl:text>
										</xsl:otherwise>	
									</xsl:choose>	
								</xsl:when>
								
								<xsl:when test="contains(//Date, 'Jul')">
									<xsl:variable name="Month" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:variable name="Months" select="string-length($Month)"/>
									<xsl:choose>
										<xsl:when test="$Months = 6">
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($Month, 3, 4)"/>
											<xsl:text>    </xsl:text>
										</xsl:when>
										<xsl:when test="$Months = 5">
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($Month, 2, 4)"/>
											<xsl:text>    </xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($Month, 1, 4)"/>
											<xsl:text>    </xsl:text>
										</xsl:otherwise>	
									</xsl:choose>	
								</xsl:when>
								
								
								<xsl:when test="contains(//Date, 'Aug')">
									<xsl:variable name="Month" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:variable name="Months" select="string-length($Month)"/>
									<xsl:choose>
										<xsl:when test="$Months = 6">
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($Month, 3, 4)"/>
											<xsl:text>    </xsl:text>
										</xsl:when>
										<xsl:when test="$Months = 5">
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($Month, 2, 4)"/>
											<xsl:text>    </xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($Month, 1, 4)"/>
											<xsl:text>    </xsl:text>
										</xsl:otherwise>	
									</xsl:choose>	
								</xsl:when>
								
								<xsl:when test="contains(//Date, 'Sep')">
									<xsl:variable name="Month" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:variable name="Months" select="string-length($Month)"/>
									<xsl:choose>
										<xsl:when test="$Months = 6">
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($Month, 3, 4)"/>
											<xsl:text>    </xsl:text>
										</xsl:when>
										<xsl:when test="$Months = 5">
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($Month, 2, 4)"/>
											<xsl:text>    </xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($Month, 1, 4)"/>
											<xsl:text>    </xsl:text>
										</xsl:otherwise>	
									</xsl:choose>	
								</xsl:when>
								
								<xsl:when test="contains(//Date, 'Oct')">
									<xsl:variable name="Month" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:variable name="Months" select="string-length($Month)"/>
									<xsl:choose>
										<xsl:when test="$Months = 6">
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($Month, 3, 4)"/>
											<xsl:text>    </xsl:text>
										</xsl:when>
										<xsl:when test="$Months = 5">
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($Month, 2, 4)"/>
											<xsl:text>    </xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($Month, 1, 4)"/>
											<xsl:text>    </xsl:text>
										</xsl:otherwise>	
									</xsl:choose>	
								</xsl:when>
								
								<xsl:when test="contains(//Date, 'Nov')">
									<xsl:variable name="Month" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:variable name="Months" select="string-length($Month)"/>
									<xsl:choose>
										<xsl:when test="$Months = 6">
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($Month, 3, 4)"/>
											<xsl:text>    </xsl:text>
										</xsl:when>
										<xsl:when test="$Months = 5">
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($Month, 2, 4)"/>
											<xsl:text>    </xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($Month, 1, 4)"/>
											<xsl:text>    </xsl:text>
										</xsl:otherwise>	
									</xsl:choose>	
								</xsl:when>
	
								<xsl:when test="contains(//Date, 'Dec')">
									<xsl:variable name="Month" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:variable name="Months" select="string-length($Month)"/>
									<xsl:choose>
										<xsl:when test="$Months = 6">
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($Month, 3, 4)"/>
											<xsl:text>    </xsl:text>
										</xsl:when>
										<xsl:when test="$Months = 5">
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($Month, 2, 4)"/>
											<xsl:text>    </xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>s</xsl:text>
											<xsl:value-of select="substring($Month, 1, 4)"/>
											<xsl:text>    </xsl:text>
										</xsl:otherwise>	
									</xsl:choose>	
								</xsl:when>
								<!-- JB Month ends -->	
								<xsl:when test="starts-with(//Date, 'Autumn')">
									<xsl:variable name="Month" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:text>s</xsl:text>
									<xsl:value-of select="substring($Month, 1, 4)"/>
									<xsl:text>    </xsl:text>
								</xsl:when>
								<xsl:when test="starts-with(//Date, 'Spring')">
									<xsl:variable name="Month" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:text>s</xsl:text>
									<xsl:value-of select="substring($Month, 1, 4)"/>
									<xsl:text>    </xsl:text>
								</xsl:when>
								<xsl:when test="starts-with(//Date, 'Summer')">
									<xsl:variable name="Month" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:text>s</xsl:text>
									<xsl:value-of select="substring($Month, 1, 4)"/>
									<xsl:text>    </xsl:text>
								</xsl:when>
								<xsl:when test="starts-with(//Date, 'Winter')">
									<xsl:variable name="Month" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:text>s</xsl:text>
									<xsl:value-of select="substring($Month, 1, 4)"/>
									<xsl:text>    </xsl:text>
								</xsl:when>
								<!-- JB n.d. replaces by uuuu- can only make it work with n.d.-->
								<xsl:when test="contains(//Date, 'n.d')">
									<xsl:text>nuuuu     </xsl:text>
									<xsl:text>    </xsl:text>
								</xsl:when>
								<xsl:when test="contains(//Date, 'N.d')">
									<xsl:text>nuuuu     </xsl:text>
									<xsl:text>    </xsl:text>
								</xsl:when>
								<xsl:when test="starts-with(//Date, 'nd')">
									<xsl:text>nuuuu     </xsl:text>
								</xsl:when>
								<xsl:when test="contains(//Date, 'undated')">
									<xsl:text>nuuuu     </xsl:text>
									<xsl:text>    </xsl:text>
								</xsl:when>
								<xsl:when test="contains(//Date, 'Undated')">
									<xsl:text>nuuuu     </xsl:text>
									<xsl:text>    </xsl:text>
								</xsl:when>
								<xsl:when test="contains(//Date, 'No date')">
									<xsl:text>nuuuu     </xsl:text>
									<xsl:text>    </xsl:text>
								</xsl:when>
								<xsl:when test="contains(//Date, 'Not dated')">
									<xsl:text>nuuuu     </xsl:text>
									<xsl:text>    </xsl:text>
								</xsl:when>
								<!-- JB end of n.d.-->
								<!-- JB heavily edited this bit, deleted many empty lines from here -->
								<!-- translate single date eg 1940s into multiple dates -->	
										<xsl:when test="contains(//Date, 's')">
											<xsl:variable name="decades" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
											<xsl:text>m</xsl:text>
											<xsl:value-of select="substring($decades, 1, 3)"/><xsl:text>0</xsl:text>
											<xsl:value-of select="substring($decades, 1, 3)"/><xsl:text>9</xsl:text>
										</xsl:when>
								<!-- JB getting rid of [] for single dates -->
								<xsl:when test="starts-with(//Date, '[')">
									<xsl:variable name="Parent" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:text>s</xsl:text>
									<xsl:value-of select="($Parent)"/>
								</xsl:when>
								<!-- JB separate dates with, only first two dates will appear on 008 mapped with m -->		
								<xsl:when test="contains(//Date, ',')">
									<xsl:variable name="Sepdates" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
										<xsl:text>m</xsl:text>
									<xsl:value-of select="substring($Sepdates, 1, 4)"/>
									<xsl:value-of select="substring($Sepdates, 5, 4)"/>
								</xsl:when>
								<xsl:when test="//Date">
									<xsl:variable name="Singledate" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
									<xsl:variable name="Months" select="string-length($Singledate)"/>
										<xsl:choose>
											<xsl:when test="$Months = 4">
												<xsl:text>s</xsl:text>
												<xsl:value-of select="($Singledate)"/>
												<xsl:text>    </xsl:text>
											</xsl:when>
											<xsl:when test="$Months = 3">
												<xsl:text>s0</xsl:text>
												<xsl:value-of select="($Singledate)"/>
												<xsl:text>    </xsl:text>
											</xsl:when>	
										</xsl:choose>
								</xsl:when>
							</xsl:choose>
					</xsl:when>
				</xsl:choose>
				
					<!--  008: positions 15-34-->
					<xsl:text>xx                  </xsl:text>
					<!-- 008 position 35-37-->
					<!-- LS added Catalan 111019-->
					<!--LS added Italian, Dutch, Swedish, Japanese, Greek 51019-->
					<xsl:choose>
						<xsl:when test="string(//Language[2])">
									<xsl:text>mul</xsl:text>
						</xsl:when>
						<xsl:when test="starts-with(//Language, 'Catalan')">
									<xsl:text>cat</xsl:text>
						</xsl:when>
						<xsl:when test="starts-with(//Language, 'Danish')">
									<xsl:text>dan</xsl:text>
						</xsl:when>
						<xsl:when test="starts-with(//Language, 'Dutch')">
									<xsl:text>dut</xsl:text>
						</xsl:when>
						<xsl:when test="starts-with(//Language, 'English')">
									<xsl:text>eng</xsl:text>
						</xsl:when>
						<xsl:when test="starts-with(//Language, 'German')">
									<xsl:text>ger</xsl:text>
						</xsl:when>
						<xsl:when test="starts-with(//Language, 'French')">
									<xsl:text>fre</xsl:text>
						</xsl:when>
						<xsl:when test="starts-with(//Language, 'Greek')">
									<xsl:text>gre</xsl:text>
						</xsl:when>
						<xsl:when test="starts-with(//Language, 'Italian')">
									<xsl:text>ita</xsl:text>
						</xsl:when>
						<xsl:when test="starts-with(//Language, 'Japanese')">
									<xsl:text>jpn</xsl:text>
						</xsl:when>
						<xsl:when test="starts-with(//Language, 'Latin')">
									<xsl:text>lat</xsl:text>
						</xsl:when>
						<xsl:when test="starts-with(//Language, 'Spanish')">
									<xsl:text>spa</xsl:text>						
						</xsl:when>
						<xsl:when test="starts-with(//Language, 'Swedish')">
									<xsl:text>swe</xsl:text>
						</xsl:when>
						<xsl:when test="starts-with(//Language, 'Portuguese')">
									<xsl:text>por</xsl:text>
						</xsl:when>
						<xsl:when test="starts-with(//Language, '')">
									<xsl:text>eng</xsl:text>
						</xsl:when>
					</xsl:choose>
		
						<!--008 positions 38-39-->
					<xsl:text>dd</xsl:text>
				</controlfield>
					<!-- End of 008 -->
		
			<xsl:choose>
				<xsl:when test="string(//RecordID)">
					<datafield tag="035" ind1="" ind2="">
						<subfield code="a"><xsl:value-of select="//RecordID"/></subfield>
					</datafield>
				</xsl:when>
			</xsl:choose>	

			
					<!-- END of 035 -->
					
					
		<datafield tag="040" ind1="" ind2="">
			<subfield code="e"><xsl:text>ISAD(G)</xsl:text></subfield>
		</datafield>
		
					<!-- JB 041 getting language mapped from natural language to abbreviation - all working up to 3 different languages -->
					<!-- LS added Catalan 111019-->
					<!-- LS added Italian, Dutch, Swedish, Japanese, Greek - up to 3 languages 151019-->
		<xsl:choose>
			<xsl:when test="string(//Language)">
				<datafield tag="041" ind1="" ind2="">
						<xsl:choose>
							<xsl:when test="starts-with(//Language, 'Catalan')">
									<subfield code="a">
										<xsl:text>cat</xsl:text>
									</subfield>
							</xsl:when>
						</xsl:choose>
						
						<xsl:choose>
							<xsl:when test="starts-with(//Language, 'Danish')">
									<subfield code="a">
										<xsl:text>dan</xsl:text>
									</subfield>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="starts-with(//Language, 'Dutch')">
									<subfield code="a">
										<xsl:text>dut</xsl:text>
									</subfield>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="starts-with(//Language, 'English')">
									<subfield code="a">
										<xsl:text>eng</xsl:text>
									</subfield>
							</xsl:when>
						</xsl:choose>
								<xsl:choose>
									<xsl:when test="starts-with(//Language, 'German')">
											<subfield code="a">
												<xsl:text>ger</xsl:text>
											</subfield>
									</xsl:when>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="starts-with(//Language, 'French')">
											<subfield code="a">
												<xsl:text>fre</xsl:text>
											</subfield>
									</xsl:when>
								</xsl:choose>
						<xsl:choose>
							<xsl:when test="starts-with(//Language, 'Greek')">
									<subfield code="a">
										<xsl:text>gre</xsl:text>
									</subfield>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="starts-with(//Language, 'Italian')">
									<subfield code="a">
										<xsl:text>ita</xsl:text>
									</subfield>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="starts-with(//Language, 'Japanese')">
									<subfield code="a">
										<xsl:text>jpn</xsl:text>
									</subfield>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="starts-with(//Language, 'Latin')">
									<subfield code="a">
										<xsl:text>lat</xsl:text>
									</subfield>
							</xsl:when>
						</xsl:choose>	
						<xsl:choose>
							<xsl:when test="starts-with(//Language, 'Spanish')">
									<subfield code="a">
										<xsl:text>spa</xsl:text>
									</subfield>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="starts-with(//Language, 'Swedish')">
									<subfield code="a">
										<xsl:text>swe</xsl:text>
									</subfield>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="starts-with(//Language, 'Portuguese')">
									<subfield code="a">
										<xsl:text>por</xsl:text>
									</subfield>		
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="starts-with(//Language[2], 'Catalan')">
									<subfield code="a">
										<xsl:text>cat</xsl:text>
									</subfield>
							</xsl:when>
						</xsl:choose>
						
						<xsl:choose>
							<xsl:when test="starts-with(//Language[2], 'Danish')">
									<subfield code="a">
										<xsl:text>dan</xsl:text>
									</subfield>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="starts-with(//Language[2], 'Dutch')">
									<subfield code="a">
										<xsl:text>dut</xsl:text>
									</subfield>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="starts-with(//Language[2], 'English')">
									<subfield code="a">
										<xsl:text>eng</xsl:text>
									</subfield>
							</xsl:when>
						</xsl:choose>
								<xsl:choose>
									<xsl:when test="starts-with(//Language[2], 'German')">
											<subfield code="a">
												<xsl:text>ger</xsl:text>
											</subfield>
									</xsl:when>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="starts-with(//Language[2], 'French')">
											<subfield code="a">
												<xsl:text>fre</xsl:text>
											</subfield>
									</xsl:when>
								</xsl:choose>
						<xsl:choose>
							<xsl:when test="starts-with(//Language[2], 'Greek')">
									<subfield code="a">
										<xsl:text>gre</xsl:text>
									</subfield>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="starts-with(//Language[2], 'Italian')">
									<subfield code="a">
										<xsl:text>ita</xsl:text>
									</subfield>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="starts-with(//Language[2], 'Japanese')">
									<subfield code="a">
										<xsl:text>jpn</xsl:text>
									</subfield>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="starts-with(//Language[2], 'Latin')">
									<subfield code="a">
										<xsl:text>lat</xsl:text>
									</subfield>
							</xsl:when>
						</xsl:choose>	
						<xsl:choose>
							<xsl:when test="starts-with(//Language[2], 'Spanish')">
									<subfield code="a">
										<xsl:text>spa</xsl:text>
									</subfield>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="starts-with(//Language[2], 'Swedish')">
									<subfield code="a">
										<xsl:text>swe</xsl:text>
									</subfield>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="starts-with(//Language[2], 'Portuguese')">
									<subfield code="a">
										<xsl:text>por</xsl:text>
									</subfield>		
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="starts-with(//Language[3], 'Catalan')">
									<subfield code="a">
										<xsl:text>cat</xsl:text>
									</subfield>
							</xsl:when>
						</xsl:choose>
						
						<xsl:choose>
							<xsl:when test="starts-with(//Language[3], 'Danish')">
									<subfield code="a">
										<xsl:text>dan</xsl:text>
									</subfield>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="starts-with(//Language[3], 'Dutch')">
									<subfield code="a">
										<xsl:text>dut</xsl:text>
									</subfield>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="starts-with(//Language[3], 'English')">
									<subfield code="a">
										<xsl:text>eng</xsl:text>
									</subfield>
							</xsl:when>
						</xsl:choose>
								<xsl:choose>
									<xsl:when test="starts-with(//Language[3], 'German')">
											<subfield code="a">
												<xsl:text>ger</xsl:text>
											</subfield>
									</xsl:when>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="starts-with(//Language[3], 'French')">
											<subfield code="a">
												<xsl:text>fre</xsl:text>
											</subfield>
									</xsl:when>
								</xsl:choose>
						<xsl:choose>
							<xsl:when test="starts-with(//Language[3], 'Greek')">
									<subfield code="a">
										<xsl:text>gre</xsl:text>
									</subfield>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="starts-with(//Language[3], 'Italian')">
									<subfield code="a">
										<xsl:text>ita</xsl:text>
									</subfield>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="starts-with(//Language[3], 'Japanese')">
									<subfield code="a">
										<xsl:text>jpn</xsl:text>
									</subfield>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="starts-with(//Language[3], 'Latin')">
									<subfield code="a">
										<xsl:text>lat</xsl:text>
									</subfield>
							</xsl:when>
						</xsl:choose>	
						<xsl:choose>
							<xsl:when test="starts-with(//Language[3], 'Spanish')">
									<subfield code="a">
										<xsl:text>spa</xsl:text>
									</subfield>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="starts-with(//Language[3], 'Swedish')">
									<subfield code="a">
										<xsl:text>swe</xsl:text>
									</subfield>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="starts-with(//Language[3], 'Portuguese')">
									<subfield code="a">
										<xsl:text>por</xsl:text>
									</subfield>		
							</xsl:when>
						</xsl:choose>	
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="contains(//Date, 'century BC')">
				<xsl:variable name="BCE" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
				<xsl:variable name="BCE2" select="string-length($BCE)"/>
				<datafield tag="046" ind1="" ind2="">
					<subfield code="a"><xsl:text>q</xsl:text></subfield>
					<xsl:choose>
					<xsl:when test="$BCE2 = 1">
					<subfield code="b">
						<xsl:value-of test="BCE" select="substring($BCE, 1, 1) - 1"/>	
						<xsl:text>99</xsl:text>
					</subfield>
					<subfield code="d">
						<xsl:value-of test="BCE" select="substring($BCE, 1, 1) - 1"/>
						<xsl:text>00</xsl:text>
					</subfield>	
					</xsl:when>	
					</xsl:choose>
					<xsl:choose>
					<xsl:when test="$BCE2 = 2">
					<subfield code="b">
						<xsl:value-of test="BCE" select="substring($BCE, 1, 2) - 1"/>
						<xsl:text>99</xsl:text>
					</subfield>	
					<subfield code="d">
						<xsl:value-of test="BCE" select="substring($BCE, 1, 2) - 1"/>
						<xsl:text>00</xsl:text>
					</subfield>		
				</xsl:when>			
			</xsl:choose>
			</datafield>
			</xsl:when>
		</xsl:choose>		
		
				<datafield tag="244" ind1="" ind2="">
					<subfield code="a"><xsl:value-of select="//AltRefNo"/></subfield>
				</datafield>
		<xsl:choose>
				<xsl:when test="starts-with(//Title, 'The')">
					<datafield tag="245" ind1="0" ind2="4">
						<subfield code="a"><xsl:call-template name="strip-tags">
							<xsl:with-param name="text" select="//Title"/>
						</xsl:call-template></subfield>
					</datafield>
			</xsl:when>
			<xsl:otherwise>
				<datafield tag="245" ind1="0" ind2="0">
					<subfield code="a"><xsl:call-template name="strip-tags">
						<xsl:with-param name="text" select="//Title"/>
					</xsl:call-template></subfield>
				</datafield>		
			</xsl:otherwise>
		</xsl:choose>
	
				<!-- JB Corrected 260|c to show value as extracted from CALM- back from 264 0 -->
		<datafield tag="260" ind1="" ind2="">
			<subfield code="c">			
			<xsl:choose>
				<xsl:when test="starts-with(//Date, 'c1')">
						<xsl:value-of select="substring-after(//Date, 'c')"/>
						<xsl:text>?</xsl:text>	
				</xsl:when>
				<xsl:when test="starts-with(//Date, 'c ')">
					<xsl:value-of select="substring-after(//Date, 'c ')"/>
					<xsl:text>?</xsl:text>	
				</xsl:when>
				<xsl:when test="starts-with(//Date, 'c.')">
					<xsl:value-of select="substring-after(//Date, 'c.')"/>
					<xsl:text>?</xsl:text>	
				</xsl:when>
				<xsl:when test="starts-with(//Date, '?c')">
					<xsl:value-of select="substring-after(//Date, 'c')"/>
					<xsl:text>?</xsl:text>
				</xsl:when>
				<xsl:when test="starts-with(//Date, '? c')">
					<xsl:value-of select="substring-after(//Date, 'c')"/>
					<xsl:text>?</xsl:text>	
				</xsl:when>
				<xsl:when test="starts-with(//Date, 'circa')">
					<xsl:value-of select="substring-after(//Date, 'circa ')"/>
					<xsl:text>?</xsl:text>	
				</xsl:when>
				<xsl:when test="starts-with(//Date, 'c, ')">
					<xsl:value-of select="substring-after(//Date, 'c, ')"/>
					<xsl:text>?</xsl:text>	
				</xsl:when>
				<xsl:when test="starts-with(//Date, 'C.')">
					<xsl:value-of select="substring-after(//Date, 'C.')"/>
					<xsl:text>?</xsl:text>	
				</xsl:when>
				<xsl:when test="starts-with(//Date, 'Circa')">
					<xsl:value-of select="substring-after(//Date, 'Circa ')"/>
					<xsl:text>?</xsl:text>	
				</xsl:when>
				<xsl:when test="starts-with(//Date, '[c')">
					<xsl:variable name="RDAc" select="translate(//Date, translate(//Date, '0123456789-', ''), '')"/>
					<xsl:value-of select="$RDAc"/>
					<xsl:text>?</xsl:text>	
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="(//Date)"/>
				</xsl:otherwise>
			</xsl:choose>	
			</subfield>
		</datafield>		
				<!-- end of 260|c -->
				<!-- JB 300's --> 
		<xsl:choose>
			<xsl:when test="string(//Extent)">
				<datafield tag="300" ind1="" ind2="">
					<subfield code="a">
						<xsl:value-of select="//Extent"/>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>

		<xsl:choose>
			<xsl:when test="string(//UserWrapped6)">
				<datafield tag="300" ind1="" ind2="">
					<subfield code="a">
						<xsl:call-template name="abbr">
							<xsl:with-param name="text" select="//UserWrapped6"/>
						</xsl:call-template>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="string(//AV_Timecode)">
				<datafield tag="306" ind1="" ind2="">
					<xsl:variable name="Time" select="translate(//AV_Timecode, translate(//AV_Timecode, '0123456789', ''), '')"/>	
					<subfield code="a">
						<xsl:value-of select="$Time"/>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<!-- 33x very unspecific, will need CALM material changes to take place before mapping in more detail-->
		<datafield tag="336" ind1="" ind2="">
				<xsl:choose>
				<xsl:when test="starts-with(//Material, 'Archives')">
					<subfield code="a">
					<xsl:text>text</xsl:text>
					</subfield>
					<subfield code="b">
					<xsl:text>txt</xsl:text>
					</subfield>
				</xsl:when>
					<xsl:when test="starts-with(//Material, 'Audio-Visual Material - Visual')">
					<subfield code="a">
					<xsl:text>two-dimensional moving image</xsl:text>
					</subfield>
					<subfield code="b">
					<xsl:text>tdi</xsl:text>
					</subfield>	
					</xsl:when>		
				<xsl:when test="contains(//Material, 'Sound only')">
					<subfield code="a">
					<xsl:text>spoken word</xsl:text>
					</subfield>
					<subfield code="b">
					<xsl:text>spw</xsl:text>
					</subfield>	
				</xsl:when>
					<xsl:when test="starts-with(//Material, 'Audio-Visual Material - e-sound only')">
						<subfield code="a">
							<xsl:text>spoken word</xsl:text>
						</subfield>
						<subfield code="b">
							<xsl:text>spw</xsl:text>
						</subfield>	
					</xsl:when>
					<xsl:when test="starts-with(//Material, 'Audio-Visual Material - e-visual only')">
						<subfield code="a">
							<xsl:text>two-dimensional moving image</xsl:text>
						</subfield>
						<subfield code="b">
							<xsl:text>tdi</xsl:text>
						</subfield>	
					</xsl:when>
					<xsl:when test="starts-with(//Material, 'Published Material')">
						<subfield code="a">
							<xsl:text>text</xsl:text>
						</subfield>
						<subfield code="b">
							<xsl:text>txt</xsl:text>
						</subfield>	
					</xsl:when>
				</xsl:choose>	
			<subfield code="2">rdacontent</subfield>
		</datafield>
		
		<datafield tag="337" ind1="" ind2="">
				<xsl:choose>
					<xsl:when test="starts-with(//Material, 'Archives - Non-digital')">
					<subfield code="a">
						<xsl:text>unmediated</xsl:text>
					</subfield>
					<subfield code="b">
						<xsl:text>n</xsl:text>
					</subfield>
					</xsl:when>	
					<xsl:when test="starts-with(//Material, 'Archives - Hybrid')">
						<subfield code="a">
							<xsl:text>unmediated</xsl:text>
						</subfield>
						<subfield code="b">
							<xsl:text>n</xsl:text>
						</subfield>
					</xsl:when>	
					<xsl:when test="starts-with(//Material, 'Archives - Digital')">
						<subfield code="a">
							<xsl:text>computer</xsl:text>
						</subfield>
						<subfield code="b">
							<xsl:text>c</xsl:text>	
						</subfield>	
					</xsl:when>		
					<xsl:when test="starts-with(//Material, 'Audio-Visual Material - Visual')">
						<subfield code="a">	
							<xsl:text>video</xsl:text>
						</subfield>
						<subfield code="b">
							<xsl:text>v</xsl:text>
						</subfield>	
				</xsl:when>		
				<xsl:when test="contains(//Material, 'Sound only')">
					<subfield code="a">
					<xsl:text>audio</xsl:text>
					</subfield>
					<subfield code="b">
					<xsl:text>s</xsl:text>
					</subfield>	
				</xsl:when>
					<xsl:when test="starts-with(//Material, 'Audio-Visual Material - e-visual only')">
						<subfield code="a">	
							<xsl:text>computer</xsl:text>
						</subfield>
						<subfield code="b">
							<xsl:text>c</xsl:text>
						</subfield>	
					</xsl:when>
					<xsl:when test="starts-with(//Material, 'Audio-Visual Material - e-sound only')">
						<subfield code="a">	
							<xsl:text>computer</xsl:text>
						</subfield>
						<subfield code="b">
							<xsl:text>c</xsl:text>
						</subfield>	
					</xsl:when>	
					<xsl:when test="starts-with(//Material, 'Published Material')">
						<subfield code="a">	
							<xsl:text>unmediated</xsl:text>
						</subfield>
						<subfield code="b">
							<xsl:text>n</xsl:text>
						</subfield>	
					</xsl:when>	
				</xsl:choose>	
			<subfield code="2">rdamedia</subfield>
		</datafield>
		
		<datafield tag="338" ind1="" ind2="">
				<xsl:choose>
					<xsl:when test="starts-with(//Material, 'Archives - Non-digital')">
						<subfield code="a">
						<xsl:text>volume</xsl:text>
						</subfield>
						<subfield code="b">
						<xsl:text>nc</xsl:text>	
						</subfield>	
					</xsl:when>
					<xsl:when test="starts-with(//Material, 'Archives - Hybrid')">
						<subfield code="a">
							<xsl:text>volume</xsl:text>
						</subfield>
						<subfield code="b">
							<xsl:text>nc</xsl:text>	
						</subfield>	
					</xsl:when>
					<xsl:when test="starts-with(//Material, 'Archives - Digital')">
						<subfield code="a">
							<xsl:text>online resource</xsl:text>
						</subfield>
						<subfield code="b">
							<xsl:text>cr</xsl:text>	
						</subfield>	
					</xsl:when>	
					<xsl:when test="starts-with(//Material, 'Audio-Visual Material - Visual')">
						<subfield code="a">
						<xsl:if test="contains(//Format, 'betacam')">
							<xsl:text>film cassette</xsl:text>
						</xsl:if>	
						<xsl:if test="contains(//Format, 'videocassette')">
							<xsl:text>film cassette</xsl:text>
						</xsl:if>
						<xsl:if test="contains(//Format, 'reel')">
							<xsl:text>film roll</xsl:text>
						</xsl:if>
						<xsl:if test="contains(//Format, 'Film - other')">
							<xsl:text>film cartridge</xsl:text>
						</xsl:if>
						<xsl:if test="contains(//Format, 'Video - other')">
							<xsl:text>film cartridge</xsl:text>
						</xsl:if>
						</subfield>
						<subfield code="b">
							<xsl:text>vd</xsl:text>
						</subfield>	
					</xsl:when>		
					<xsl:when test="contains(//Material, 'Sound only')">
						<subfield code="a">
						<xsl:text>audio disc</xsl:text>
						</subfield>
						<subfield code="b">
						<xsl:text>sd</xsl:text>
						</subfield>	
					</xsl:when>
					<xsl:when test="starts-with(//Material, 'Audio-Visual Material - e-sound only')">
						<subfield code="a">
							<xsl:text>online resource</xsl:text>
						</subfield>
						<subfield code="b">
							<xsl:text>cr</xsl:text>
						</subfield>	
					</xsl:when>
					<xsl:when test="starts-with(//Material, 'Audio-Visual Material - e-visual only')">
						<subfield code="a">
							<xsl:text>online resource</xsl:text>
						</subfield>
						<subfield code="b">
							<xsl:text>cr</xsl:text>
						</subfield>	
					</xsl:when>
					<xsl:when test="starts-with(//Material, 'Published Material')">
						<subfield code="a">
							<xsl:text>volume</xsl:text>
						</subfield>
						<subfield code="b">
							<xsl:text>nc</xsl:text>
						</subfield>	
					</xsl:when>
				</xsl:choose>	
			<subfield code="2">rdacarrier</subfield>
		</datafield>
		
		<xsl:choose>
			<xsl:when test="string(//Arrangement)">
				<datafield tag="351" ind1="" ind2="">
					<subfield code="a"><xsl:value-of select="//Arrangement"/></subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="string(//Level)">
				<datafield tag="351" ind1="" ind2="">
					<subfield code="c"><xsl:value-of select="//Level"/><xsl:text> record level.</xsl:text></subfield>
					<subfield code="b"><xsl:value-of select="//Ordering_Instructions"/></subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		
				<!-- END 300's -->
				
				<!-- new 500's by JB --> 
		
				<!-- Maybe it would be better to make it separate 506 to allow to hide field when not populated, otherwise "available" will appear even if no date is given (eg) --> 
	<xsl:choose>
		<xsl:when test="string(//RepositoryCode)">
		<datafield tag="535" ind1="1" ind2="">
			
			<subfield code="a">
				<xsl:choose>
					<xsl:when test="contains(//RepositoryCode, '0248')">
						<xsl:text>Glasgow University Archive Services, University of Glasgow, Glasgow</xsl:text>
					</xsl:when>
					<xsl:when test="contains(//RepositoryCode, '0103')">
						<xsl:text>UCL: Special Collections</xsl:text>
					</xsl:when>
					<xsl:when test="contains(//RepositoryCode, '0100')">
						<xsl:text>King's College London Archives</xsl:text>
					</xsl:when>
					<xsl:when test="contains(//RepositoryCode, '0014')">
						<xsl:text>Churchill Archives Centre, Churchill College, Cambridge</xsl:text>
					</xsl:when>
					<xsl:when test="contains(//RepositoryCode, 'NCshB')">
						<xsl:text>Cold Spring Harbor Laboratory Archives and Genentech Center for the History of Molecular Biology and Biotechnology NY, USA</xsl:text>
					</xsl:when>
					<xsl:when test="contains(//RepositoryCode, '0120')">
						<xsl:text>Wellcome Library</xsl:text>
					</xsl:when>
					<xsl:when test="contains(//RepositoryCode, '1115')">
						<xsl:text>Museum of Military Medicine</xsl:text>
					</xsl:when>
					<xsl:when test="contains(//RepositoryCode, 'AML')">
						<xsl:text>Martin Leake family</xsl:text>
					</xsl:when>
					<xsl:when test="contains(//RepositoryCode, '193')">
						<xsl:text>Borthwick Institute for Archives, the University of York</xsl:text>
					</xsl:when>
					<xsl:when test="contains(//RepositoryCode, '74')">
						<xsl:text>London Metropolitan Archives</xsl:text>
					</xsl:when>
					<xsl:when test="contains(//RepositoryCode, '812')">
						<xsl:text>NHS Greater Glasgow and Clyde Archives</xsl:text>
					</xsl:when>
					<xsl:when test="contains(//RepositoryCode, '226')">
						<xsl:text>Dumfries and Galloway Archives and Local Studies</xsl:text>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="string(//CountryCode)">
						<xsl:text>;</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>.</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</subfield>
			<xsl:choose>
				<xsl:when test="string(//CountryCode)">
					<subfield code="c">
						<xsl:value-of select="//CountryCode"/>
						<xsl:text>.</xsl:text>
					</subfield>		
				</xsl:when>
			</xsl:choose>
			<!-- surpressed in V67
				<subfield code="g">
				<xsl:choose>
				<xsl:when test="contains(//CountryCode, 'GB')">
				<xsl:text>xxk</xsl:text>
				</xsl:when>
				<xsl:when test="contains(//CountryCode, 'US')">
				<xsl:text>nyu</xsl:text>
				</xsl:when>
				</xsl:choose>
				</subfield>	-->
		</datafield>
		</xsl:when>
	</xsl:choose>		
		<xsl:choose>
			<xsl:when test="string(//PreviousNumbers)">
				<datafield tag="515" ind1="" ind2="">
					<subfield code="a"><xsl:text>Previous Number: </xsl:text><xsl:value-of select="//PreviousNumbers"/></subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<!-- added in v 61-->
		<xsl:choose>
			<xsl:when test="string(//CreatorName)">
				<datafield tag="508" ind1="" ind2="">
					<subfield code="a"><xsl:value-of select="//CreatorName"/></subfield>
				</datafield>
			</xsl:when>	
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Credits)">
				<datafield tag="508" ind1="" ind2="">
					<subfield code="a"><xsl:value-of select="//Credits"/></subfield>
				</datafield>
			</xsl:when>	
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Description)">
				<xsl:choose>
					<xsl:when test="starts-with(//AltRefNo, 'TP')">
					
						<xsl:call-template name="underlined"/>
			
				</xsl:when>
				<xsl:otherwise>			
				<xsl:variable name="short" select="(//Description)"/>
				<xsl:variable name="shortz" select="string-length($short)"/>
				<xsl:choose>
					<xsl:when test="$shortz > 1">
						<datafield tag="520" ind1="2" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//Description,0,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$shortz > 9990">
						<datafield tag="520" ind1="2" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//Description,9991,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$shortz > 19980">
						<datafield tag="520" ind1="2" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//Description,19981,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$shortz > 20970">
						<datafield tag="520" ind1="2" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//Description,20971,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$shortz > 30960">
						<datafield tag="520" ind1="2" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//Description,30961,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$shortz > 40950">
						<datafield tag="520" ind1="2" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//Description,40951,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$shortz > 50940">
						<datafield tag="520" ind1="2" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//Description,50941,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>
				</xsl:otherwise>
				</xsl:choose>	
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="string(//AV_Target_Audience)">
				<datafield tag="521" ind1="" ind2="">
					<subfield code="a"><xsl:value-of select="//AV_Target_Audience"/></subfield>
				</datafield>
			</xsl:when>	
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="string(//AdminHistory)">
				<xsl:variable name="little" select="(//AdminHistory)"/>
				<xsl:variable name="littlez" select="string-length($little)"/>
				<xsl:choose>
					<xsl:when test="$littlez > 1">
						<datafield tag="545" ind1="" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//AdminHistory,0,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$littlez > 9990">
						<datafield tag="545" ind1="" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//AdminHistory,9990,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$littlez > 19981">
						<datafield tag="545" ind1="" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//AdminHistory,19982,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$littlez > 29972">
						<datafield tag="545" ind1="" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//AdminHistory,29973,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$littlez > 39963">
						<datafield tag="545" ind1="" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//AdminHistory,39964,9999)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$littlez > 49954">
						<datafield tag="545" ind1="" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//AdminHistory,49955,9999)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>							
			</xsl:when>
		</xsl:choose>
		<!-- JB sorted! -->
		<xsl:choose>
			<xsl:when test="string(//Language)">
				<datafield tag="546" ind1="" ind2="">
					<subfield code="a">
						<xsl:text>In </xsl:text>
						<xsl:value-of select="//Language"/>
						<xsl:choose>
							<xsl:when test="string(//Language[2])">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="//Language[2]"/>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="string(//Language[3])">
								<xsl:text> and </xsl:text>
								<xsl:value-of select="//Language[3]"/>
							</xsl:when>
						</xsl:choose>
						<xsl:text>.</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//CustodialHistory)">
				<xsl:variable name="short" select="(//CustodialHistory)"/>
				<xsl:variable name="shortz" select="string-length($short)"/>
				<xsl:choose>
					<xsl:when test="$shortz > 1">
						<datafield tag="561" ind1="1" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//CustodialHistory,0,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$shortz > 9990">
						<datafield tag="561" ind1="1" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//CustodialHistory,9990,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$shortz > 19980">
						<datafield tag="561" ind1="1" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//CustodialHistory,19981,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$shortz > 20970">
						<datafield tag="561" ind1="1" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//CustodialHistory,20971,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$shortz > 30960">
						<datafield tag="561" ind1="1" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//CustodialHistory,30961,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$shortz > 40950">
						<datafield tag="561" ind1="1" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//CustodialHistory,40951,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$shortz > 50940">
						<datafield tag="561" ind1="1" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//CustodialHistory,50941,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>							
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Acquisition)">
				<datafield tag="541" ind1="" ind2="">
					<subfield code="a">
						<xsl:value-of select="//Acquisition"/>
					</subfield>
					<!-- accno will be repeated insert template for multiple -->
					<xsl:choose>
						<xsl:when test="string(//AccNo)">
							<xsl:apply-templates select="//AccNo"/>
						</xsl:when>
					</xsl:choose>					
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Appraisal)">
				<datafield tag="583" ind1="" ind2="">
					<subfield code="a"><xsl:value-of select="//Appraisal"/></subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Accruals)">
				<datafield tag="584" ind1="" ind2="">
					<subfield code="a"><xsl:value-of select="//Accruals"/></subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="contains(//AccessStatus, 'At Digitisation')">
			<datafield tag="856" ind1="4" ind2="2">
				<subfield code="u">
					<xsl:text>http://wellcomelibrary.org/what-we-do/digitisation/digitisation-schedules/</xsl:text>
				</subfield>
				<subfield code="z">
					<xsl:text>This item is currently at digitisation. View the schedule here.</xsl:text>
				</subfield>
			</datafield>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="string(//AccessConditions)">
					<datafield tag="506" ind1="" inde2="">
						<subfield code="a"><xsl:value-of select="//AccessConditions"/>
				<xsl:choose>		
				<xsl:when test="contains(//ClosedUntil, '/')">
					<xsl:text>- Available from: </xsl:text><xsl:value-of select="//ClosedUntil"/>	
				</xsl:when>
				<xsl:when test="contains(//UserDate1, '/')">
					<xsl:text>- Restricted until: </xsl:text><xsl:value-of select="//UserDate1"/><xsl:text>. </xsl:text>
				</xsl:when>
				</xsl:choose>	
						</subfield>
						<subfield code="f"><xsl:value-of select="//AccessStatus"/><xsl:text>.</xsl:text></subfield>	
					</datafield>	
				</xsl:if>		
			</xsl:otherwise>
				
				
		</xsl:choose>	
		<datafield tag="540" ind1="" ind2="">
			<subfield code="a"><xsl:value-of select="//UserWrapped1"/></subfield>		
		</datafield>
		<xsl:choose>
			<xsl:when test="string(//Copyright)">
				<datafield tag="542" ind1="" ind2="">
					<subfield code="a">
						<xsl:call-template name="strip-tags">
							<xsl:with-param name="text" select="//Copyright"/>
						</xsl:call-template>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<!-- Originals mapped to 535 2 in v 68 -->
			<xsl:choose>
			<xsl:when test="string(//Originals)">
				<datafield tag="535" ind1="2" ind2="">
					<subfield code="a"><xsl:value-of select="//Originals"/></subfield>
				</datafield>
			</xsl:when>
			</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="string(//Copies)">
				<datafield tag="535" ind1="2" ind2="">
					<subfield code="a"><xsl:value-of select="//Copies"/></subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>		
				
		<xsl:choose>
			<xsl:when test="string(//RelatedMaterial)">
				<xsl:variable name="short" select="(//RelatedMaterial)"/>
				<xsl:variable name="shortz" select="string-length($short)"/>
				<xsl:choose>
					<xsl:when test="$shortz > 1">
						<datafield tag="544" ind1="" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//RelatedMaterial,0,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$shortz > 9990">
						<datafield tag="544" ind1="" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//RelatedMaterial,9990,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$shortz > 19980">
						<datafield tag="544" ind1="" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//RelatedMaterial,19981,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$shortz > 20970">
						<datafield tag="544" ind1="" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//RelatedMaterial,20971,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$shortz > 30960">
						<datafield tag="544" ind1="" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//RelatedMaterial,30961,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$shortz > 40950">
						<datafield tag="544" ind1="" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//RelatedMaterial,40951,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$shortz > 50940">
						<datafield tag="544" ind1="" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//RelatedMaterial,50941,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>							
			</xsl:when>
		</xsl:choose>

		<xsl:choose>
			<xsl:when test="string(//PublnNote)">
				<datafield tag="581" ind1="" ind2="">
					<subfield code="a"><xsl:value-of select="//PublnNote"/></subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>

		<xsl:choose>
			<xsl:when test="string(//Notes)">
				<xsl:variable name="short" select="(//Notes)"/>
				<xsl:variable name="shortz" select="string-length($short)"/>
				<xsl:choose>
					<xsl:when test="$shortz > 1">
						<datafield tag="500" ind1="" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//Notes,0,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$shortz > 9990">
						<datafield tag="500" ind1="" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//Notes,9990,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$shortz > 19980">
						<datafield tag="500" ind1="" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//Notes,19981,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$shortz > 20970">
						<datafield tag="500" ind1="" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//Notes,20971,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$shortz > 30960">
						<datafield tag="500" ind1="" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//Notes,30961,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$shortz > 40950">
						<datafield tag="500" ind1="" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//Notes,40951,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$shortz > 50940">
						<datafield tag="500" ind1="" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//Notes,50941,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>							
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Notes[2])">
				<xsl:variable name="short" select="(//Notes[2])"/>
				<xsl:variable name="shortz" select="string-length($short)"/>
				<xsl:choose>
					<xsl:when test="$shortz > 1">
						<datafield tag="500" ind1="" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//Notes[2],0,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$shortz > 9990">
						<datafield tag="500" ind1="" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//Notes[2],9990,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$shortz > 19980">
						<datafield tag="500" ind1="" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//Notes[2],19981,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$shortz > 20970">
						<datafield tag="500" ind1="" ind2="">
							<subfield code="a">
								<xsl:value-of select="substring(//Notes[2],20971,9990)"/>
							</subfield>					
						</datafield>
					</xsl:when>
				</xsl:choose>						
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//UserWrapped4)">
				<datafield tag="555" ind1="" ind2="">
					<subfield code="a">
						<xsl:call-template name="strip-tags">
							<xsl:with-param name="text" select="//UserWrapped4"/>
						</xsl:call-template>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		
		<!-- JB I don't know how to generate the proper name out of the authority file!!I'm assuming here that the code is now proper text. Also where should I put the URL??
		<xsl:choose>
			<xsl:when test="string(//PersonCode)">
				<datafield tag="600" ind1="1" ind2="0">
					<subfield code="a">
					<xsl:value-of select="//PersonCode"/>
					</subfield>
				</datafield>
			</xsl:when>
			</xsl:choose>-->
		<!-- JB 650's- separating mesh form LCSH  -->
		<xsl:choose>	
			<xsl:when test="string(Subject)">
					<xsl:choose>
						<xsl:when test="contains(Subject, '&lt;')">
							<datafield tag="650" ind1="0" ind2="0">
								<xsl:call-template name="LCSH"/>
							</datafield>
						</xsl:when>
						<xsl:otherwise>
							<datafield tag="650" ind1="0" ind2="2">
								<subfield code="a"><xsl:value-of select="Subject"/></subfield>
							</datafield>
						</xsl:otherwise>	
					</xsl:choose>
			</xsl:when>
		</xsl:choose>		
		<xsl:choose>
			<xsl:when test="string(Subject[2])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[2], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH2"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[2]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(Subject[3])">
				<xsl:choose>
					<xsl:when test="contains(Subject[3], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH3"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[3]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(Subject[4])">
				<xsl:choose>
					<xsl:when test="contains(Subject[4], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH4"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[4]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[5])">
				<xsl:choose>
					<xsl:when test="contains(Subject[5], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH5"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[5]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[6])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[6], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH6"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[6]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[7])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[7], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH7"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[7]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[8])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[8], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH8"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[8]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[9])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[9], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH9"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[9]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[10])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[10], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH10"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[10]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>	
			<xsl:when test="string(//Subject[11])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[11], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH11"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[11]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>		
		<xsl:choose>
			<xsl:when test="string(//Subject[12])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[12], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH12"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[12]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[13])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[13], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH13"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[13]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[14])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[14], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH14"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[14]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[15])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[15], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH15"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[15]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[16])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[16], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH16"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[16]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[17])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[17], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH17"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[17]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[18])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[18], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH18"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[18]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[19])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[19], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH19"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[19]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[20])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[20], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH20"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[20]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>	
			<xsl:when test="string(//Subject[21])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[21], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH21"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[21]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>		
		<xsl:choose>
			<xsl:when test="string(//Subject[22])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[22], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH22"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[22]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[23])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[23], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH23"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[23]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[24])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[24], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH24"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[24]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[25])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[25], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH25"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[25]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[26])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[26], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH26"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[26]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[27])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[27], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH27"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[27]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[28])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[28], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH28"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[28]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[29])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[29], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH29"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[29]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[30])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[30], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH30"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[30]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>	
			<xsl:when test="string(//Subject[31])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[31], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH31"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[31]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>		
		<xsl:choose>
			<xsl:when test="string(//Subject[32])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[32], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH32"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[32]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[33])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[33], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH33"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[33]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[34])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[34], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH34"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[34]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[35])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[35], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH35"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[35]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[36])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[36], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH36"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[36]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[37])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[37], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH37"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[37]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[38])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[38], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH38"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[38]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[39])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[39], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH39"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[39]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[40])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[40], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH40"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[40]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>	
			<xsl:when test="string(//Subject[41])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[41], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH41"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[41]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>		
		<xsl:choose>
			<xsl:when test="string(//Subject[42])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[42], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH42"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[42]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[43])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[43], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH43"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[43]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[44])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[44], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH44"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[44]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[45])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[45], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH45"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[45]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[46])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[46], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH46"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[46]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[47])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[47], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH47"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[47]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[48])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[48], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH48"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[48]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[49])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[49], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH49"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[49]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[50])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[50], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH50"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[50]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>	
			<xsl:when test="string(//Subject[51])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[51], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH51"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[51]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>		
		<xsl:choose>
			<xsl:when test="string(//Subject[52])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[52], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH52"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[52]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[53])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[53], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH53"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[53]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[54])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[54], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH54"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[54]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[55])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[55], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH55"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[55]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[56])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[56], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH56"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[56]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[57])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[57], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH57"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[57]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[58])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[58], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH58"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[58]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[59])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[59], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH59"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[59]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Subject[60])">
				<xsl:choose>
					<xsl:when test="contains(//Subject[60], '&lt;')">
						<datafield tag="650" ind1="0" ind2="0">
							<xsl:call-template name="LCSH60"/>
						</datafield>
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="650" ind1="0" ind2="2">
							<subfield code="a"><xsl:value-of select="Subject[60]"/></subfield>
						</datafield>
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(//Place)">
				<xsl:apply-templates select="//Place"/>
			</xsl:when>
		</xsl:choose>
		<datafield tag="655" ind1="" ind2="0">
					<subfield code="a"><xsl:text>Archives.</xsl:text></subfield>
		</datafield>
		<xsl:choose>
			<xsl:when test="starts-with(//Material, 'Audio-Visual Material - Visual')">
				<datafield tag="655" ind1="" ind2="0">
					<subfield code="a"><xsl:text>Video recordings.</xsl:text></subfield>
				</datafield>			
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//Material, 'Audio-Visual Material - e-visual only')">
				<datafield tag="655" ind1="" ind2="0">
					<subfield code="a"><xsl:text>Video recordings.</xsl:text></subfield>
				</datafield>			
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="contains(//Material, 'Sound')">
				<datafield tag="655" ind1="" ind2="0">
					<subfield code="a"><xsl:text>Sound recordings.</xsl:text></subfield>
				</datafield>			
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//Material, 'Audio-Visual Material - e-sound only')">
				<datafield tag="655" ind1="" ind2="7">
					<subfield code="a"><xsl:text>Sound recordings.</xsl:text></subfield>
					<subfiled code="2"><xsl:text>lcgft</xsl:text></subfiled>
				</datafield>			
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//AltRefNo, 'NIMR')">
					<xsl:if test="contains(//Extent, 'Pamphlet')">
						<datafield tag="655" ind1="" ind2="7">
						<subfield code="a"><xsl:text>Pamphlets.</xsl:text></subfield>
						<subfiled code="2"><xsl:text>gmgpc</xsl:text></subfiled>
						</datafield>	
					</xsl:if>
					<xsl:if test="contains(//Extent, 'Dissertation')">
						<datafield tag="655" ind1="" ind2="7">
						<subfield code="a"><xsl:text>Academic dissertations.</xsl:text></subfield>
						<subfiled code="2"><xsl:text>rbgenr</xsl:text></subfiled>
						</datafield>
					</xsl:if>		
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//AltRefNo, 'GALTON')">
				<datafield tag="773" ind1="0" ind2="">
					<subfield code="t">
						<xsl:text>Galton Papers</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//AltRefNo, 'HALDANE')">
				<datafield tag="773" ind1="0" ind2="">
					<subfield code="t">
						<xsl:text>Haldane Papers</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//AltRefNo, 'PENROSE')">
				<datafield tag="773" ind1="0" ind2="">
					<subfield code="t">
						<xsl:text>Penrose Papers</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//RefNo, 'PPCRI')">
				<datafield tag="773" ind1="0" ind2="">
					<subfield code="t">
						<xsl:text>Francis Crick Papers</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//RefNo, 'PPAEM')">
				<datafield tag="773" ind1="0" ind2="">
					<subfield code="t">
						<xsl:text>Arthur Mourant Papers</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//RefNo, 'PPCPB')">
				<datafield tag="773" ind1="0" ind2="">
					<subfield code="t">
						<xsl:text>Carlos Paton Blacker Papers</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//RefNo, 'SB')">
				<datafield tag="773" ind1="0" ind2="">
					<subfield code="t">
						<xsl:text>Sydney Brenner Papers</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//RefNo, 'SAEUG')">
				<datafield tag="773" ind1="0" ind2="">
					<subfield code="t">
						<xsl:text>Eugenics Society Archive</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//RefNo, 'PPHBF')">
				<datafield tag="773" ind1="0" ind2="">
					<subfield code="t">
						<xsl:text>Honor Fell Papers</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//RefNo, 'UGC188')">
				<datafield tag="773" ind1="0" ind2="">
					<subfield code="t">
						<xsl:text>Malcolm Ferguson-Smith Papers</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//RefNo, 'FRKN')">
				<datafield tag="773" ind1="0" ind2="">
					<subfield code="t">
						<xsl:text>Rosalind Franklin Papers</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//RefNo, 'PPGRU')">
				<datafield tag="773" ind1="0" ind2="">
					<subfield code="t">
						<xsl:text>Hans Gr�neberg Papers</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//RefNo, 'PPPBM')">
				<datafield tag="773" ind1="0" ind2="">
					<subfield code="t">
						<xsl:text>Peter Medawar Papers</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//RefNo, 'JDW')">
				<datafield tag="773" ind1="0" ind2="">
					<subfield code="t">
						<xsl:text>James Watson Papers</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//RefNo, 'SABGU')">
				<datafield tag="773" ind1="0" ind2="">
					<subfield code="t">
						<xsl:text>Medical Research Council Blood Group Unit Archive</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//RefNo, 'UGC198')">
				<datafield tag="773" ind1="0" ind2="">
					<subfield code="t">
						<xsl:text>Guido Pontecorvo Papers</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//RefNo, 'PPSAR')">
				<datafield tag="773" ind1="0" ind2="">
					<subfield code="t">
						<xsl:text>Robert Race and Ruth Sanger Papers</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//RefNo, 'UGC155')">
				<datafield tag="773" ind1="0" ind2="">
					<subfield code="t">
						<xsl:text>James Renwick Papers</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//RefNo, 'SABIO')">
				<datafield tag="773" ind1="0" ind2="">
					<subfield code="t">
						<xsl:text>Frederick Sanger Papers</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//RefNo, 'KPP178')">
				<datafield tag="773" ind1="0" ind2="">
					<subfield code="t">
						<xsl:text>Maurice Wilkins Papers</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//RefNo, 'PPGRW')">
				<datafield tag="773" ind1="0" ind2="">
					<subfield code="t">
						<xsl:text>Gerard Wyatt Papers</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//CreatorName, 'Ticehurst House Hospital')">
				<datafield tag="773" ind1="0" ind2="">
					<subfield code="t">
						<xsl:text>Ticehurst House Hospital Papers</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//RefNo, 'RET')">
				<datafield tag="773" ind1="0" ind2="">
					<subfield code="t">
						<xsl:text>The Retreat Archive</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//RefNo, 'HB13')">
				<datafield tag="773" ind1="0" ind2="">
					<subfield code="t">
						<xsl:text>Records of Gartnavel Royal Hospital</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//RefNo, 'H64')">
				<datafield tag="773" ind1="0" ind2="">
					<subfield code="t">
						<xsl:text>St Luke's Hospital</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//RefNo, 'DGH1')">
				<datafield tag="773" ind1="0" ind2="">
					<subfield code="t">
						<xsl:text>Records of Crichton Royal Hospital</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//RefNo, 'MS5157')">
				<datafield tag="773" ind1="0" ind2="">
					<subfield code="t">
						<xsl:text>Holloway Sanatorium Hospital for the Insane, Virginia Water, Surrey</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//RefNo, 'MS5725')">
				<datafield tag="773" ind1="0" ind2="">
					<subfield code="t">
						<xsl:text>Manor House Asylum</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//RefNo, 'MS6220')">
				<datafield tag="773" ind1="0" ind2="">
					<subfield code="t">
						<xsl:text>Camberwell House Asylum</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//RefNo, 'MS5510')">
				<datafield tag="773" ind1="0" ind2="">
					<subfield code="t">
						<xsl:text>James Adam (1834-1908): archives</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//RefNo, 'PPADD')">
				<datafield tag="773" ind1="0" ind2="">
					<subfield code="t">
						<xsl:text>Robina Addis (1900-1986): archives</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//RefNo, 'MS4566')">
				<datafield tag="773" ind1="0" ind2="">
					<subfield code="t">
						<xsl:text>George Edward Shuttleworth (1842-1928): archives</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//RefNo, 'NIMR')">
				<datafield tag="773" ind1="0" ind2="">
					<subfield code="t">
						<xsl:text>NIMR Archive Collection</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//UserText9, 'Recipe')">
				<datafield tag="759" ind1="" ind2="">
					<subfield code="a">
						<xsl:text>digrecipe</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>	
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//UserText9, 'Foundations')">
				<datafield tag="759" ind1="" ind2="">
					<subfield code="a">
						<xsl:text>diggenetics</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>	
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//UserText9, 'Mental health')">
				<datafield tag="759" ind1="" ind2="">
					<subfield code="a">
						<xsl:text>digasylum</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>	
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//RefNo, 'MS6220')">
				<datafield tag="759" ind1="" ind2="">
					<subfield code="a">
						<xsl:text>digcamberwell</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>	
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="starts-with(//AltRefNo, 'RCPSYCH/X1')">
				<datafield tag="759" ind1="" ind2="">
					<subfield code="a">
						<xsl:text>digcamberwell</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>	
		</xsl:choose>
				<!-- Sets the link back URL -->
				<!-- When DserveII is running, replace the URL below with the following URL -->
				<!-- http://archives.wellcome.ac.uk/DServe/dserve.exe?&dsqIni=Dserve.ini&dsqApp=Archive&dsqCmd=show.tcl&dsqDb=Catalog&dsqPos=0&dsqSearch=((text)=' I think this is already working so I replaced it-->
				<!-- cycle to CALM removed in v 89 <datafield tag="856" ind1="4" ind2="">
					<subfield code="u">
						<xsl:text>http://archives.wellcomelibrary.org/DServe/dserve.exe?&amp;dsqIni=Dserve.ini&amp;dsqApp=Archive&amp;dsqCmd=show.tcl&amp;dsqDb=Catalog&amp;dsqPos=0&amp;dsqSearch=(AltRefNo='</xsl:text>
						<xsl:value-of select="//AltRefNo"/>
						<xsl:text>')</xsl:text>
					</subfield>
					<subfield code="z">View record in Archives catalogue</subfield>
				</datafield>-->
		<xsl:choose>
			<xsl:when test="contains(//AccessConditions, 'Galton Institute')">
				<datafield tag="856" ind1="4" ind2="">
					<subfield code="u">
						<xsl:text>http://www.galtoninstitute.org.uk</xsl:text>
					</subfield>
					<subfield code="z">go to Galton Institute webpage</subfield>
				</datafield>	
			</xsl:when>
		</xsl:choose>
	
		<xsl:choose>
			<xsl:when test="contains(//Link_To_Digitised, 'wellcomelibrary.org')">
				
				<datafield tag="856" ind1="4" ind2="1">
					<subfield code="u">
						<xsl:call-template name="recipeurl"/>
					</subfield>
					<subfield code="z">view this image</subfield>
				</datafield>	
					
			</xsl:when>
		</xsl:choose>
	
	
	<!-- Jb waiting for url example to activate
	<xsl:choose>	
		<xsl:when test="contains(//Level, 'Collection')">
		<datafield tag="856" ind1="4" ind2="">
			<subfield code="u">
				<xsl:value-of select="//Document"/>
			</subfield>
			<subfield code="z">View catalogue</subfield>
		</datafield>
		</xsl:when>
	</xsl:choose>
	-->	
		
		<datafield tag="905" ind1="" ind2="">
				<subfield code="a"><xsl:value-of select="//RefNo"/></subfield>
		</datafield>
		
		<!-- 907removed 2014-->	

		<!-- added in jan 2015 to start mapping MAterial type more accurately. Load table was also changed.-->
		<xsl:choose>
			<xsl:when test="string(//Material)">
			<datafield tag="998" ind1="" ind2="">
			<subfield code="b">
				<xsl:choose> 
					<xsl:when test="contains(//Material, 'Sound only')">
						<xsl:text>i</xsl:text>
					</xsl:when>
					<xsl:when test="starts-with(//Material, 'Audio-Visual Material - Visual')">
						<xsl:text>g</xsl:text>
					</xsl:when>
					<xsl:when test="starts-with(//Material, 'Audio-Visual Material - e-sound only')">
						<xsl:text>s</xsl:text>
					</xsl:when>
					<xsl:when test="starts-with(//Material, 'Audio-Visual Material - e-visual only')">
						<xsl:text>f</xsl:text>
					</xsl:when>
					<xsl:when test="starts-with(//Material, 'Published Material')">
						<xsl:text>a</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>h</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</subfield>
			</datafield>	
			</xsl:when>
		</xsl:choose>	

<!--V 94Changed to test ordering codes to give item. Non item, not own should no have this field poupulated-->		
		<xsl:choose>
			<xsl:when test="string(//UserText3)">
<!-- V73 reverted back to using level=item to create attached item level. This replaced ordering code and was done because some non-item level had ordering code-->
		<xsl:choose>
			<xsl:when test="contains(//Level, 'Item')">
				<datafield tag="949" ind1="0" ind2="0">					
					<!-- Shelf mark information -->
					<subfield code="a">
						<xsl:variable name="AV" select="string-length(//MISC_Reference)"/>
						<xsl:if test="$AV >1">
						<xsl:value-of select="//MISC_Reference"/>
						</xsl:if>	
						<xsl:if test="$AV =0">
						<xsl:value-of select="//AltRefNo"/>	
						</xsl:if>	
					</subfield>	
					<!--<xsl:choose>-->
					<!--below displays |b as barcode field (tag b).  This was attempt to get the box number displaying as |b in the shelfmark field.  This would need some work on load table to map correctly.  It is currently displaying as barcode b tag field.  Not pursued as decision made to add Box details to the Current Location field.-->
					<!--<subfield code="b">					
								<xsl:if test="string(//UserText6)">
								<xsl:text>:Box </xsl:text>
								<xsl:value-of select="//UserText6"/>
								</xsl:if>
					</subfield>-->
					<!-- LS CALM Location field to Sierra Current Location field 03/07/24-->
					<!-- Tested and working-->
					<!-- Box number appended to Current Location shelfmark. 12/12/24-->
					<!-- LS attempt to add mapping for a second Location field where there are multiple CUrrent Locations in the CALM record.  Not working, currently greyed out-->
				
					<subfield code="k">					
								<xsl:if test="string(//Location)">
								<xsl:value-of select="//Location"/>
								</xsl:if>
							<xsl:choose>
							<xsl:when test="string(//UserText6)">
								<xsl:text>;Box</xsl:text>
								<xsl:value-of select="//UserText6"/>
								<xsl:if test="string(//UserText7)">
									<xsl:text>; </xsl:text>
								</xsl:if>
							</xsl:when>
						</xsl:choose>
					</subfield>			
					
				<!-- LS Following is attempt to add mapping for a second Location field where there are multiple CUrrent Locations in the CALM record.  Isn't working at present. -->
				<!-- <subfield code="k">					
								<xsl:if test="string(//Location)">
								<xsl:value-of select="//Location"/>
								</xsl:if>
							<xsl:choose>
							<xsl:when test="string(//UserText6)">
								<xsl:text>;Box</xsl:text>
								<xsl:value-of select="//UserText6"/>
								<xsl:if test="string(//UserText7)">
									<xsl:text>; </xsl:text>
								</xsl:if>
							</xsl:when>
						</xsl:choose>
					</subfield>
					<subfield code="k">					
								<xsl:if test="string(//Location/2)">
								<xsl:value-of select="//Location/2"/>
								</xsl:if>
							<xsl:choose>
							<xsl:when test="string(//UserText6)">
								<xsl:text>;Box</xsl:text>
								<xsl:value-of select="//UserText6"/>
								<xsl:if test="string(//UserText7)">
									<xsl:text>; </xsl:text>
								</xsl:if>
							</xsl:when>
						</xsl:choose>
					</subfield> -->
					
					<!--Following hashed out as Toni Hardy said only 'Box' is used. 26/06/24 -->
					<!--</xsl:choose>-->
					
								<!--<xsl:if test="string(//UserText7)">
									<xsl:text>; </xsl:text>-->
								<!--</xsl:if>-->							
							<!--</xsl:when>-->
					<!--</xsl:choose>-->
						<!--<xsl:choose>
							<xsl:when test="string(//UserText7)">
									<xsl:choose>
										<xsl:when test="string(UserText6)">
											<xsl:text>File </xsl:text><xsl:value-of select="//UserText7"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>:File </xsl:text><xsl:value-of select="//UserText7"/>
										</xsl:otherwise>
									</xsl:choose>
							</xsl:when>						
						</xsl:choose>--> 
						<!--<xsl:choose>
							<xsl:when test="string(//UserText8)">
								<xsl:choose>
									<xsl:when test="string(UserText6)">
										<xsl:text>; </xsl:text><xsl:value-of select="//AltRefNo"/><xsl:text>:O/S </xsl:text><xsl:value-of select="//UserText8"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>:O/S </xsl:text><xsl:value-of select="//UserText8"/>
									</xsl:otherwise>
								</xsl:choose>					
							</xsl:when>
						</xsl:choose>-->
					
				
	
				
					
					<subfield code="l">
						<!-- Creates Innopac codes for locations -->
						<xsl:choose>
							<!-- Archives -->
							<xsl:when test="contains(//UserText3, 'Archives - Requestable')">
								<xsl:text>scmac</xsl:text>
							</xsl:when>
							
							<xsl:when test="contains(//UserText3, 'Archives - Not Requestable')">
								<xsl:text>sc#ac</xsl:text>
							</xsl:when>
							
							<!-- RAMC -->
							<xsl:when test="contains(//UserText3, 'RAMC publications - Requestable')">
								<xsl:text>scmra</xsl:text>
							</xsl:when>
							
							<xsl:when test="contains(//UserText3, 'RAMC publications - Not Requestable')">
								<xsl:text>sc#ra</xsl:text>
							</xsl:when>
						
							<!-- Wellcome Archives -->
							<xsl:when test="contains(//UserText3, 'Wellcome Archives - Requestable')">
								<xsl:text>scmwa</xsl:text>
							</xsl:when>
							
							<xsl:when test="contains(//UserText3, 'Wellcome Archives - Not Requestable')">
								<xsl:text>sc#wa</xsl:text>
							</xsl:when>
							
							<!-- Wellcome Foundation -->
							<xsl:when test="contains(//UserText3, 'Wellcome Foundation - Requestable')">
								<xsl:text>scmwf</xsl:text>
							</xsl:when>
							
							<xsl:when test="contains(//UserText3, 'Wellcome Foundation - Not Requestable')">
								<xsl:text>sc#wf</xsl:text>
							</xsl:when>
							
							<!-- American MSS -->
							<xsl:when test="contains(//UserText3, 'American MSS - Requestable')">
								<xsl:text>swmam</xsl:text>
							</xsl:when>
							
							<xsl:when test="contains(//UserText3, 'American MSS - Not Requestable')">
								<xsl:text>swm#m</xsl:text>
							</xsl:when>
							
							<!-- Medical Society of London MSS -->
							<xsl:when test="contains(//UserText3, 'Medical Society of London MSS. - Requestable')">
								<xsl:text>swmlo</xsl:text>
							</xsl:when>
							
							<xsl:when test="contains(//UserText3, 'Medical Society of London - Not Requestable')">
								<xsl:text>swm#o</xsl:text>
							</xsl:when>
							
							<!-- Western MSS series 1 -->
							<xsl:when test="contains(//UserText3, 'Western MSS series 1 - Requestable')">
								<xsl:text>swms1</xsl:text>
							</xsl:when>
							
							<xsl:when test="contains(//UserText3, 'Western MSS series 1 - Not Requestable')">
								<xsl:text>swm#1</xsl:text>
							</xsl:when>
							
							<!-- Western MSS series 2-->
							<xsl:when test="contains(//UserText3, 'Western MSS series 2 - Requestable')">
								<xsl:text>swms2</xsl:text>
							</xsl:when>
							
							<xsl:when test="contains(//UserText3, 'Western MSS series 2- Not Requestable')">
								<xsl:text>swm#2</xsl:text>
							</xsl:when>
						
							<!-- Western MSS series 3-->
							<xsl:when test="contains(//UserText3, 'Western MSS series 3 - Requestable')">
								<xsl:text>swms3</xsl:text>
							</xsl:when>
							
							<xsl:when test="contains(//UserText3, 'Western MSS series 3 - Not Requestable')">
								<xsl:text>swm#3</xsl:text>
							</xsl:when>
							
							<!-- Western MSS series 4-->
							<xsl:when test="contains(//UserText3, 'Western MSS series 4 - Requestable')">
								<xsl:text>swms4</xsl:text>
							</xsl:when>
							
							<xsl:when test="contains(//UserText3, 'Western MSS series 4 - Not Requestable')">
								<xsl:text>swm#4</xsl:text>
							</xsl:when>
							
							<!-- Western MSS series 5 -->
							<xsl:when test="contains(//UserText3, 'Western MSS series 5 - Requestable')">
								<xsl:text>swms5</xsl:text>
							</xsl:when>
							
							<xsl:when test="contains(//UserText3, 'Western MSS series 5 - Not Requestable')">
								<xsl:text>swm#5</xsl:text>
							</xsl:when>
							
							<!-- Western MSS series 6 -->
							<xsl:when test="contains(//UserText3, 'Western MSS series 6 - Requestable')">
								<xsl:text>swms6</xsl:text>
							</xsl:when>
							
							<xsl:when test="contains(//UserText3, 'Western MSS series 6 - Not Requestable')">
								<xsl:text>swm#6</xsl:text>
							</xsl:when>
							
							<!-- Western MSS series 7 -->
							<xsl:when test="contains(//UserText3, 'Western MSS series 7 - Requestable')">
								<xsl:text>swms7</xsl:text>
							</xsl:when>
							
							<xsl:when test="contains(//UserText3, 'Western MSS series 7- Not Requestable')">
								<xsl:text>swm#7</xsl:text>
							</xsl:when>
							<!-- Audio-visual non-requestable -->		
							
							<xsl:when test="contains(//UserText3, 'Audio-Visual Material (4.49) - Not Requestable')">
								<xsl:text>mfvac</xsl:text>
							</xsl:when>
							
							<xsl:when test="contains(//UserText3, 'Audio-Visual Material (Cold store 4.44) - Not Requestable')">
								<xsl:text>mfohc</xsl:text>
							</xsl:when>
							
							<!-- 'Audio-Visual Material (closed store) - By appointment' = Deleted heading in CALM 21/6/23 -->
							<!-- <xsl:when test="contains(//UserText3, 'Audio-Visual Material (closed store) - By appointment')">
								<xsl:text>mfohc</xsl:text>
							</xsl:when> -->
							
							<!-- 'Audio-Visual Material (4th floor) - By appointment' = Deleted heading in CALM 21/6/23 -->
							<!-- <xsl:when test="contains(//UserText3, 'Audio-Visual Material (4th floor) - By appointment')">
								<xsl:text>mfohc</xsl:text>
							</xsl:when> -->
							
							<xsl:when test="contains(//UserText3, 'Visual Material - Not Requestable')">
								<xsl:text>sicon</xsl:text>
							</xsl:when>
							
							<xsl:when test="contains(//UserText3, 'Audio-Visual Material (3.73) - Not Requestable')">
								<xsl:text>mfvac</xsl:text>
							</xsl:when>
							
							<!-- Audio-visual requestable -->
							
							<xsl:when test="contains(//UserText3, 'Audio-Visual Material (4.49) - Requestable')">
								<xsl:text>mfvac</xsl:text>
							</xsl:when>
							
							<xsl:when test="contains(//UserText3, 'Audio-Visual Material (3.73) - Requestable')">
								<xsl:text>mfvac</xsl:text>
							</xsl:when>
							
							<xsl:when test="contains(//UserText3, 'Audio-Visual Material (closed store) - Requestable')">
								<xsl:text>mfvac</xsl:text>
							</xsl:when>
							
							<xsl:when test="contains(//UserText3, 'Visual Material - Requestable')">
								<xsl:text>sicon</xsl:text>
							</xsl:when>
							
														
						</xsl:choose>
					</subfield>
					
					<!-- o= OPACmessage, s=status! Changed in version 90 to map status and opac message-->
					<xsl:choose>
						<!-- LS hashed our ordering status 11/11 14:15
						<xsl:when test="contains(//Ordering_Status, 'By Appointment')">
							<subfield code="o">
								<xsl:text>a</xsl:text>
							</subfield>-->
							<!--<subfield code="s">
								<xsl:text>y</xsl:text>
							</subfield>-->
						<!--</xsl:when>-->
						<!--<xsl:when test="contains(//AccessStatus, 'Certain restrictions apply')">
							<subfield code="o">
								<xsl:text>f</xsl:text>
							</subfield>
							<subfield code="s">
								<xsl:text>-</xsl:text>
							</subfield>
						</xsl:when>-->
						<xsl:when test="contains(//AccessStatus, 'Closed')">
							<!--<subfield code="o">
								<xsl:text>u</xsl:text>
							</subfield>-->
							<subfield code="s">
								<xsl:text>r</xsl:text>
							</subfield>
						</xsl:when>
						<xsl:when test="contains(//AccessStatus, 'Deaccessioned')">
							<!--<subfield code="o">
								<xsl:text>u</xsl:text>
							</subfield>-->
							<subfield code="s">
								<xsl:text>x</xsl:text>
							</subfield>
						</xsl:when>
						<!-- LS hashed out missing 11/11 14:15
						<xsl:when test="contains(//AccessStatus, 'Missing')">
							<subfield code="o">
								<xsl:text>u</xsl:text>
							</subfield>
							<subfield code="s">
								<xsl:text>m</xsl:text>
							</subfield>
						</xsl:when>-->
						<xsl:when test="contains(//AccessStatus, 'Open')">
							<!--<subfield code="o">
								<xsl:text>f</xsl:text>
							</subfield>-->
							<subfield code="s">
								<xsl:text>-</xsl:text>
							</subfield>
						</xsl:when>
						<xsl:when test="contains(//AccessStatus, 'Open with advisory')">
							<!--<subfield code="o">
								<xsl:text>f</xsl:text>
							</subfield>-->
							<subfield code="s">
								<xsl:text>-</xsl:text>
							</subfield>
						</xsl:when>
						<xsl:when test="contains(//AccessStatus, 'Permission required')">
							<!-- LS hashed out 11/11 12:00
							<subfield code="o">
								<xsl:text>q</xsl:text>
							</subfield>-->
							<subfield code="s">
								<xsl:text>y</xsl:text>
							</subfield>
						</xsl:when>
						<xsl:when test="contains(//AccessStatus, 'Restricted')">
							<!--<subfield code="o">
								<xsl:text>c</xsl:text>
							</subfield>-->
							<subfield code="s">
								<xsl:text>-</xsl:text>
							</subfield>
						</xsl:when>
						<xsl:when test="contains(//AccessStatus, 'Temporarily Unavailable')">
							<!--<subfield code="o">
								<xsl:text>u</xsl:text>
							</subfield>-->
							<subfield code="s">
								<xsl:text>r</xsl:text>
							</subfield>
						</xsl:when>
						<xsl:when test="contains(//AccessStatus, 'Safeguarded')">
							<!-- LS hashed out 11/11 12:30 
							<subfield code="o">
								<xsl:text>p</xsl:text>
							</subfield>-->
							<subfield code="s">
								<xsl:text>g</xsl:text>
							</subfield>
						</xsl:when>
					</xsl:choose>
					
															
					<!-- LS added Ordering_status mapping to opacmsg (o) 11/11/25-->
					<xsl:choose>
						<xsl:when test="contains(//Ordering_Status, 'Unavailable')">
							<subfield code="o">
								<xsl:text>u</xsl:text>
							</subfield>
							</xsl:when>
						</xsl:choose>
					
					<xsl:choose>
						<xsl:when test="contains(//Ordering_Status, 'Online request')">
							<subfield code="o">
								<xsl:text>f</xsl:text>
							</subfield>
							</xsl:when>
						<xsl:when test="contains(//Ordering_Status, 'By appointment')">
							<subfield code="o">
								<xsl:text>a</xsl:text>
							</subfield>
							</xsl:when>
						<xsl:when test="contains(//Ordering_Status, 'At digitisation')">
							<subfield code="o">
								<xsl:text>b</xsl:text>
							</subfield>
							</xsl:when>
						<xsl:when test="contains(//Ordering_Status, 'Restricted')">
							<subfield code="o">
								<xsl:text>c</xsl:text>
							</subfield>
							</xsl:when>
						<xsl:when test="contains(//Ordering_Status, 'Manual request')">
							<subfield code="o">
								<xsl:text>n</xsl:text>
							</subfield>
							</xsl:when>
						<xsl:when test="contains(//Ordering_Status, 'By approval')">
							<subfield code="o">
								<xsl:text>p</xsl:text>
							</subfield>
						</xsl:when>
						<xsl:when test="contains(//Ordering_Status, 'Missing')">
							<subfield code="o">
								<xsl:text>u</xsl:text>
							</subfield>
						</xsl:when>
						</xsl:choose>
					
					<xsl:choose>
						<!-- Itype mappings AV -->
						<xsl:when test="contains(//Material, 'Visual')">
							<subfield code="w">
							<!-- 11/03/25 LS added the 4.49 shelfmark to test mapping from Ordering code to itype.  The other AV mappings have to be updated in both test and production. -->
								<xsl:if test="starts-with(//UserText3, 'Audio-Visual Material (4.49) - Not Requestable')">
									<xsl:text>15</xsl:text>
								</xsl:if>
								<xsl:if test="starts-with(//UserText3, 'Audio-Visual Material (closed store) - Not Requestable')">
									<xsl:text>15</xsl:text>
								</xsl:if>
								<!-- 'Audio-Visual Material (closed store) - By appointment' = Deleted heading in CALM 21/6/23 -->
								<!--<xsl:if test="starts-with(//UserText3, 'Audio-Visual Material (closed store) - By appointment')">
									<xsl:text>15</xsl:text>
								</xsl:if> -->
								
								<!-- 'Audio-Visual Material (4th floor) - By appointment' = Deleted heading in CALM 21/6/23 -->
								<!-- <xsl:if test="starts-with(//UserText3, 'Audio-Visual Material (4th floor) - By appointment')">
									<xsl:text>15</xsl:text>
								</xsl:if> -->
								
								<xsl:if test="starts-with(//UserText3, 'Audio-Visual Material (4th floor) - Requestable')">
									<xsl:text>16</xsl:text>
								</xsl:if>
								<xsl:if test="starts-with(//UserText3, 'Audio-Visual Material (3th floor) - Requestable')">
									<xsl:text>16</xsl:text>
								</xsl:if>
								<xsl:if test="starts-with(//UserText3, 'Audio-Visual Material (closed store) - Requestable')">
									<xsl:text>16</xsl:text>
								</xsl:if>
							</subfield>	
						</xsl:when>
						<!-- Itype Sound records -->
						<xsl:when test="contains(//Material, 'Sound only')">
							<subfield code="w">
								<xsl:if test="starts-with(//UserText3, 'Audio-Visual Material (4th floor) - Not Requestable')">
									<xsl:text>18</xsl:text>
								</xsl:if>
								<xsl:if test="starts-with(//UserText3, 'Audio-Visual Material (closed store) - Not Requestable')">
									<xsl:text>18</xsl:text>
								</xsl:if>
								<!-- 'Audio-Visual Material (closed store) - By appointment' = Deleted heading in CALM 21/6/23 -->
								<!-- <xsl:if test="starts-with(//UserText3, 'Audio-Visual Material (closed store) - By appointment')">
									<xsl:text>18</xsl:text>
								</xsl:if> -->
								<!-- 'Audio-Visual Material (4th floor) - By appointment' = Deleted heading in CALM 21/6/23 -->
								<!-- <xsl:if test="starts-with(//UserText3, 'Audio-Visual Material (4th floor) - By appointment')">
									<xsl:text>18</xsl:text>
								</xsl:if> -->
								
								<xsl:if test="starts-with(//UserText3, 'Audio-Visual Material (4th floor) - Requestable')">
									<xsl:text>19</xsl:text>
								</xsl:if>
								<xsl:if test="starts-with(//UserText3, 'Audio-Visual Material (3th floor) - Requestable')">
									<xsl:text>19</xsl:text>
								</xsl:if>
								<xsl:if test="starts-with(//UserText3, 'Audio-Visual Material (closed store) - Requestable')">
									<xsl:text>19</xsl:text>
								</xsl:if>
							</subfield>
						</xsl:when>
						<!-- Itype Archives non-digital records - both requestable and non-requestable 120625-->
						<xsl:when test="starts-with(//Material, 'Archives - Non-digital')">
							<xsl:text>9</xsl:text>
							<subfield code="w">
							<xsl:if test="starts-with(//UserText3, 'Archives - Requestable')">
									<xsl:text>9</xsl:text>
								</xsl:if>
								<xsl:if test="starts-with(//UserText3, 'Archives - Not Requestable')">
									<xsl:text>9</xsl:text>
								</xsl:if>
								
								<!--<xsl:if test="starts-with(//UserText3, 'Audio-Visual Material (4th floor) - Requestable')">
									<xsl:text>16</xsl:text>
								</xsl:if>
								<xsl:if test="starts-with(//UserText3, 'Audio-Visual Material (3th floor) - Requestable')">
									<xsl:text>16</xsl:text>
								</xsl:if>
								<xsl:if test="starts-with(//UserText3, 'Audio-Visual Material (closed store) - Requestable')">
									<xsl:text>16</xsl:text>
								</xsl:if>-->
							</subfield>	
						</xsl:when>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="starts-with(//Notes, 'Barcode')">
							<subfield code="e">
								<xsl:variable name="Barcode" select="translate(//Notes, translate(//Notes, '0123456789', ''), '')"/>
								<xsl:value-of select="substring($Barcode,1,11)"/>
							</subfield>	
						</xsl:when>
					</xsl:choose>
				</datafield>
			</xsl:when>
			
			<!-- added in v 63 to provide 945 for non item records for goobi-->
			<xsl:otherwise>
				<datafield tag="945" ind1="" ind2="">
					<subfield code="a"><xsl:value-of select="//AltRefNo"/></subfield>
				</datafield>	
			</xsl:otherwise>			
		</xsl:choose>	
			</xsl:when>
			<xsl:otherwise>
				<datafield tag="945" ind1="" ind2="">
					<subfield code="a"><xsl:value-of select="//AltRefNo"/></subfield>
				</datafield>	
			</xsl:otherwise>
		</xsl:choose>
		
		<!--added for multiple bib locations in version 60 -->
		<datafield tag="959" ind1="" ind2="">
			<subfield code="1"><xsl:text>arch</xsl:text></subfield>
		</datafield>

		<!--added for dlnk -->
		<xsl:choose>
			<xsl:when test="starts-with(//Player_Code, 'View')">
				<datafield tag="959" ind1="" ind2="">
					<subfield code="1">
						<xsl:text>dlnk</xsl:text>
					</subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="string(//UserText3)">
				<xsl:call-template name="itemloc"/>
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="starts-with(//Material, 'Audio-Visual Material - Visual')">
				<datafield tag="959" ind1="" ind2="">
					<subfield code="1"><xsl:text>mfvl</xsl:text></subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="contains(//Material, 'Sound only')">
				<datafield tag="959" ind1="" ind2="">
					<subfield code="1"><xsl:text>mfvl</xsl:text></subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="contains(//Material, ' - e-')">
				<datafield tag="959" ind1="" ind2="">
					<subfield code="1"><xsl:text>elro</xsl:text></subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="contains(//Material, 'e-sound')">
				<datafield tag="959" ind1="" ind2="">
					<subfield code="1"><xsl:text>mfvl</xsl:text></subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="contains(//Material, ' - e-')">
				<datafield tag="959" ind1="" ind2="">
					<subfield code="1"><xsl:text>digi</xsl:text></subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		
		<!--changed to Digitised -->
		<!--edited out digi and dlnk in v 93 because these must be inserted after goobi upload, this happens in Sierra
		<xsl:choose>
			<xsl:when test="starts-with(//Digitised, 'Y')">
				<datafield tag="959" ind1="" ind2="">
					<subfield ="1"><xsl:text>digi</xsl:text></subfield>
				</datafield>
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="starts-with(//ExitNote, 'Y')">
				<xsl:if test="starts-with(//Digitised, 'Y')">
					<datafield tag="959" ind1="" ind2="">
						<subfield ="1">
							<xsl:text>dlnk</xsl:text>
						</subfield>
					</datafield>
				</xsl:if>	
			</xsl:when>
		</xsl:choose>-->
		<!-- End of multiple Bib loc -->
		
		
			</record>
	
</xsl:template>

<!-- JB: "title" template is not being used for 245. As far as I understand the below only creates a variable and nothing more. I'm leaving it here for the time being because I'm not sure if it is being use in another part of the XSLT --> 
<xsl:template match="//Title" mode="title">
	<xsl:apply-templates/>
</xsl:template>
	
<xsl:template match="//AccNo">	
		<subfield code="e">
			<xsl:apply-templates/>
		</subfield>
</xsl:template>	
	
<xsl:template match="//Place">	
	<datafield tag="651" ind1="" ind2="1">
		<subfield code="a">
			<xsl:apply-templates/>
		</subfield>
	</datafield>
</xsl:template>

<xsl:template match="//i">
	<xsl:value-of select="."/>
</xsl:template>

<xsl:template match="//b">
	<xsl:value-of select="."/>
</xsl:template>

<xsl:template match="//u">
	<xsl:value-of select="."/>
</xsl:template>

<!-- very interesting template below, allows application of variable to different tags-->
	

	<xsl:template name="strip-tags">
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when test="contains($text, '&lt;')">
				<xsl:value-of select="substring-before($text, '&lt;')"/>
				<xsl:call-template name="strip-tags">
					<xsl:with-param name="text" select="substring-after($text, '&gt;')"/>
				</xsl:call-template>	
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
<!-- refining URL for piece level recipe records-->	
	<xsl:template name="recipeurl">
		<xsl:choose>
			<xsl:when test="contains(//Link_To_Digitised, 'player')">
				<xsl:variable name="url1" select="substring-after(//Link_To_Digitised, '&lt;a href=&quot;')"/>
				<xsl:variable name="url2" select="substring-before($url1, 'target=&quot;')"/>
				<xsl:value-of select="$url2"/>
			</xsl:when>	
		</xsl:choose>
	</xsl:template>
	
<!-- added to version 149 to make |xsubdivision on LCSH-->

	<xsl:template name="LCSH">
		<xsl:variable name="Libcon" select="substring-after(Subject, '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH2">
		<xsl:variable name="Libcon" select="substring-after(Subject[2], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH3">
		<xsl:variable name="Libcon" select="substring-after(Subject[3], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH4">
		<xsl:variable name="Libcon" select="substring-after(Subject[4], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH5">
		<xsl:variable name="Libcon" select="substring-after(Subject[5], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH6">
		<xsl:variable name="Libcon" select="substring-after(Subject[6], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH7">
		<xsl:variable name="Libcon" select="substring-after(Subject[7], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH8">
		<xsl:variable name="Libcon" select="substring-after(Subject[8], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH9">
		<xsl:variable name="Libcon" select="substring-after(Subject[9], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH10">
		<xsl:variable name="Libcon" select="substring-after(Subject[10], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH11">
		<xsl:variable name="Libcon" select="substring-after(Subject[11], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH12">
		<xsl:variable name="Libcon" select="substring-after(Subject[12], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH13">
		<xsl:variable name="Libcon" select="substring-after(Subject[13], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH14">
		<xsl:variable name="Libcon" select="substring-after(Subject[14], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH15">
		<xsl:variable name="Libcon" select="substring-after(Subject[15], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH16">
		<xsl:variable name="Libcon" select="substring-after(Subject[16], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH17">
		<xsl:variable name="Libcon" select="substring-after(Subject[17], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH18">
		<xsl:variable name="Libcon" select="substring-after(Subject[18], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH19">
		<xsl:variable name="Libcon" select="substring-after(Subject[19], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH20">
		<xsl:variable name="Libcon" select="substring-after(Subject[20], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH21">
		<xsl:variable name="Libcon" select="substring-after(Subject[21], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH22">
		<xsl:variable name="Libcon" select="substring-after(Subject[22], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH23">
		<xsl:variable name="Libcon" select="substring-after(Subject[23], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH24">
		<xsl:variable name="Libcon" select="substring-after(Subject[24], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH25">
		<xsl:variable name="Libcon" select="substring-after(Subject[25], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH26">
		<xsl:variable name="Libcon" select="substring-after(Subject[26], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH27">
		<xsl:variable name="Libcon" select="substring-after(Subject[27], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH28">
		<xsl:variable name="Libcon" select="substring-after(Subject[28], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH29">
		<xsl:variable name="Libcon" select="substring-after(Subject[29], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH30">
		<xsl:variable name="Libcon" select="substring-after(Subject[30], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH31">
		<xsl:variable name="Libcon" select="substring-after(Subject[31], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH32">
		<xsl:variable name="Libcon" select="substring-after(Subject[32], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH33">
		<xsl:variable name="Libcon" select="substring-after(Subject[33], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH34">
		<xsl:variable name="Libcon" select="substring-after(Subject[34], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH35">
		<xsl:variable name="Libcon" select="substring-after(Subject[35], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH36">
		<xsl:variable name="Libcon" select="substring-after(Subject[36], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH37">
		<xsl:variable name="Libcon" select="substring-after(Subject[37], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH38">
		<xsl:variable name="Libcon" select="substring-after(Subject[38], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH39">
		<xsl:variable name="Libcon" select="substring-after(Subject[39], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH40">
		<xsl:variable name="Libcon" select="substring-after(Subject[40], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH41">
		<xsl:variable name="Libcon" select="substring-after(Subject[41], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH42">
		<xsl:variable name="Libcon" select="substring-after(Subject[42], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH43">
		<xsl:variable name="Libcon" select="substring-after(Subject[43], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH44">
		<xsl:variable name="Libcon" select="substring-after(Subject[44], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH45">
		<xsl:variable name="Libcon" select="substring-after(Subject[45], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH46">
		<xsl:variable name="Libcon" select="substring-after(Subject[46], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH47">
		<xsl:variable name="Libcon" select="substring-after(Subject[47], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH48">
		<xsl:variable name="Libcon" select="substring-after(Subject[48], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH49">
		<xsl:variable name="Libcon" select="substring-after(Subject[49], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH50">
		<xsl:variable name="Libcon" select="substring-after(Subject[50], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH51">
		<xsl:variable name="Libcon" select="substring-after(Subject[51], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH52">
		<xsl:variable name="Libcon" select="substring-after(Subject[52], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH53">
		<xsl:variable name="Libcon" select="substring-after(Subject[53], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH54">
		<xsl:variable name="Libcon" select="substring-after(Subject[54], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH55">
		<xsl:variable name="Libcon" select="substring-after(Subject[55], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH56">
		<xsl:variable name="Libcon" select="substring-after(Subject[56], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH57">
		<xsl:variable name="Libcon" select="substring-after(Subject[57], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH58">
		<xsl:variable name="Libcon" select="substring-after(Subject[58], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH59">
		<xsl:variable name="Libcon" select="substring-after(Subject[59], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LCSH60">
		<xsl:variable name="Libcon" select="substring-after(Subject[60], '&lt;p&gt;')"/>
		<xsl:choose>
			<xsl:when test="contains($Libcon, '--')">
				<xsl:variable name="Libcon1" select="substring-before($Libcon, '--')"/>
				<xsl:variable name="Libcon2" select="substring-after($Libcon, '--')"/>
				<subfield code="a"><xsl:value-of select="$Libcon1"/></subfield>
				<subfield code="x"><xsl:value-of select="$Libcon2"/></subfield>
			</xsl:when>	
			<xsl:otherwise>
				<subfield code="a"><xsl:value-of select="$Libcon"/></subfield>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="abbr">
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when test="contains($text, 'll.')">
				<xsl:value-of select="substring-before($text, 'll.')"/>
				<xsl:text>leaves</xsl:text>
				<xsl:call-template name="abbr">
					<xsl:with-param name="text" select="substring-after($text, 'll.')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, 'pp.')">
				<xsl:value-of select="substring-before($text, 'pp.')"/>
				<xsl:text>pages</xsl:text>
				<xsl:call-template name="abbr">
					<xsl:with-param name="text" select="substring-after($text, 'pp.')"/>
				</xsl:call-template>	
			</xsl:when>
			<xsl:when test="contains($text, 'ff.')">
				<xsl:value-of select="substring-before($text, 'ff.')"/>
				<xsl:text>folios</xsl:text>
				<xsl:call-template name="abbr">
					<xsl:with-param name="text" select="substring-after($text, 'ff.')"/>
				</xsl:call-template>	
			</xsl:when>
			<xsl:when test="contains($text, 'bl.')">
				<xsl:value-of select="substring-before($text, 'bl.')"/>
				<xsl:text>blank</xsl:text>
				<xsl:call-template name="abbr">
					<xsl:with-param name="text" select="substring-after($text, 'bl.')"/>
				</xsl:call-template>	
			</xsl:when>
			<xsl:when test="contains($text, 'vols.')">
				<xsl:value-of select="substring-before($text, 'vols.')"/>
				<xsl:text>volumes</xsl:text>
				<xsl:call-template name="abbr">
					<xsl:with-param name="text" select="substring-after($text, 'vols.')"/>
				</xsl:call-template>	
			</xsl:when>
			<xsl:when test="contains($text, 'vol.')">
				<xsl:value-of select="substring-before($text, 'vol.')"/>
				<xsl:text>volume</xsl:text>
				<xsl:call-template name="abbr">
					<xsl:with-param name="text" select="substring-after($text, 'vol.')"/>
				</xsl:call-template>	
			</xsl:when>
			<xsl:when test="contains($text, 'l.')">
				<xsl:value-of select="substring-before($text, 'l.')"/>
				<xsl:text>leave</xsl:text>
				<xsl:call-template name="abbr">
					<xsl:with-param name="text" select="substring-after($text, 'l.')"/>
				</xsl:call-template>	
			</xsl:when>
			<xsl:when test="contains($text, 'p.')">
				<xsl:value-of select="substring-before($text, 'p.')"/>
				<xsl:text>page</xsl:text>
				<xsl:call-template name="abbr">
					<xsl:with-param name="text" select="substring-after($text, 'p.')"/>
				</xsl:call-template>	
			</xsl:when>
			<xsl:when test="contains($text, 'f.')">
				<xsl:value-of select="substring-before($text, 'f.')"/>
				<xsl:text>folio</xsl:text>
				<xsl:call-template name="abbr">
					<xsl:with-param name="text" select="substring-after($text, 'f.')"/>
				</xsl:call-template>	
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- trying to underline links to audio resource-->
	<xsl:template name="underlined">
				<xsl:choose>
					<xsl:when test="contains(//Description, '&lt;a href')">
						<xsl:variable name="under1" select="substring-before(//Description, '&lt;a href')"/>
						<xsl:variable name="under2" select="substring-after(//Description, '&lt;a href')"/>
						<datafield tag="520" ind1="2" ind2="">
						<subfield code="a">
							<xsl:value-of select="($under1)"/>
							<xsl:text>&lt;u&gt;&lt;a href</xsl:text>
							<xsl:value-of select="($under2)"/>
							<xsl:text>&lt;/u&gt;</xsl:text>
						</subfield>
						</datafield>	
					</xsl:when>
					<xsl:otherwise>
						<datafield tag="520" ind1="2" ind2="">
							<subfield code="a"><xsl:value-of select="(//Description)"/></subfield>
						</datafield>	
					</xsl:otherwise>
				</xsl:choose>
	</xsl:template>

	<xsl:template name="webdisplay">
		<xsl:choose>
			<xsl:when test="starts-with(//Level, 'Item')">
				<xsl:text>d</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>e</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template name="itemloc">
		<xsl:choose>
			<xsl:when test="starts-with(//Level, 'Item')">
				<datafield tag="959" ind1="" ind2="">
					<subfield code="1">
				<xsl:text>stax</xsl:text>
					</subfield>	
				</datafield>	
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="numerals">
		<xsl:choose>
		<xsl:when test="contains(//Date, 'seventeenth')">
			<xsl:text>m16001639</xsl:text>
		</xsl:when>	
		<xsl:when test="contains(//Date, 'Seventeenth')">
			<xsl:text>m16001639</xsl:text>
		</xsl:when>		
		<xsl:when test="contains(//Date, 'eighteenth')">
			<xsl:text>m17001739</xsl:text>
		</xsl:when>	
		<xsl:when test="contains(//Date, 'Eighteenth')">
			<xsl:text>m17001739</xsl:text>
		</xsl:when>		
		<xsl:when test="contains(//Date, 'nineteenth')">
			<xsl:text>m18001839</xsl:text>
		</xsl:when>	
		<xsl:when test="contains(//Date, 'Nineteenth')">
			<xsl:text>m18001839</xsl:text>
		</xsl:when>		
		<xsl:when test="contains(//Date, 'twentieth')">
			<xsl:text>m19001939</xsl:text>
		</xsl:when>	
		<xsl:when test="contains(//Date, 'Twentieth')">
			<xsl:text>m19001939</xsl:text>
		</xsl:when>		
		</xsl:choose>	
	</xsl:template>
	
	<xsl:template name="numerals2">
		<xsl:choose>
			<xsl:when test="contains(//Date, 'seventeenth')">
				<xsl:text>m16301669</xsl:text>
			</xsl:when>	
			<xsl:when test="contains(//Date, 'Seventeenth')">
				<xsl:text>m16301669</xsl:text>
			</xsl:when>	
			<xsl:when test="contains(//Date, 'eighteenth')">
				<xsl:text>m17301769</xsl:text>
			</xsl:when>	
			<xsl:when test="contains(//Date, 'Eighteenth')">
				<xsl:text>m17301769</xsl:text>
			</xsl:when>	
			<xsl:when test="contains(//Date, 'nineteenth')">
				<xsl:text>m18301869</xsl:text>
			</xsl:when>	
			<xsl:when test="contains(//Date, 'Nineteenth')">
				<xsl:text>m18301869</xsl:text>
			</xsl:when>	
			<xsl:when test="contains(//Date, 'twentieth')">
				<xsl:text>m19301969</xsl:text>
			</xsl:when>	
			<xsl:when test="contains(//Date, 'Twentieth')">
				<xsl:text>m19301969</xsl:text>
			</xsl:when>	
		</xsl:choose>	
	</xsl:template>
	
	<xsl:template name="numerals3">
		<xsl:choose>
			<xsl:when test="contains(//Date, 'seventeenth')">
				<xsl:text>m16601699</xsl:text>
			</xsl:when>	
			<xsl:when test="contains(//Date, 'Seventeenth')">
				<xsl:text>m16601699</xsl:text>
			</xsl:when>	
			<xsl:when test="contains(//Date, 'eighteenth')">
				<xsl:text>m17601799</xsl:text>
			</xsl:when>	
			<xsl:when test="contains(//Date, 'Eighteenth')">
				<xsl:text>m17601799</xsl:text>
			</xsl:when>	
			<xsl:when test="contains(//Date, 'nineteenth')">
				<xsl:text>m18601899</xsl:text>
			</xsl:when>	
			<xsl:when test="contains(//Date, 'Nineteenth')">
				<xsl:text>m18601899</xsl:text>
			</xsl:when>	
			<xsl:when test="contains(//Date, 'twentieth')">
				<xsl:text>m19601999</xsl:text>
			</xsl:when>	
			<xsl:when test="contains(//Date, 'Twentieth')">
				<xsl:text>m19601999</xsl:text>
			</xsl:when>	
		</xsl:choose>	
	</xsl:template>
	<!--templates for dates staring with "early"-->
	<xsl:template name="earlyearlystart">
		<xsl:variable name="Fuzzy" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
		<xsl:variable name="MCen" select="string-length($Fuzzy)"/>
		<xsl:variable name="CNS" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
		<xsl:choose>
			<xsl:when test="$MCen = 4">
				<xsl:variable name="century" select="substring($CNS, 1, 2)"/>
				<xsl:variable name="years" select="$century - 1"/>
				<xsl:text>m</xsl:text>
				<xsl:value-of select="$years"/>
				<xsl:text>00</xsl:text>
				<xsl:variable name="Century" select="substring($CNS, 3, 2)"/>
				<xsl:variable name="Years" select="$Century - 1"/>
				<xsl:value-of select="$Years"/>
				<xsl:text>39</xsl:text>
			</xsl:when>	
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="earlymidstart">
		<xsl:variable name="Fuzzy" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
		<xsl:variable name="MCen" select="string-length($Fuzzy)"/>
		<xsl:variable name="CNS" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
		<xsl:choose>
			<xsl:when test="$MCen = 4">
			<xsl:variable name="century" select="substring($CNS, 1, 2)"/>
			<xsl:variable name="years" select="$century - 1"/>
			<xsl:text>m</xsl:text>
			<xsl:value-of select="$years"/>
			<xsl:text>00</xsl:text>
				<xsl:variable name="Century" select="substring($CNS, 3, 2)"/>
			<xsl:variable name="Years" select="$Century - 1"/>
			<xsl:value-of select="$Years"/>
			<xsl:text>69</xsl:text>
			</xsl:when>	
			<xsl:when test="$MCen = 2">
				<xsl:variable name="century" select="substring($CNS, 1, 2)"/>
				<xsl:variable name="years" select="$century - 1"/>
				<xsl:text>m</xsl:text>
				<xsl:value-of select="$years"/>
				<xsl:text>00</xsl:text>
				<xsl:variable name="Century" select="substring($CNS, 1, 2)"/>
				<xsl:variable name="Years" select="$Century - 1"/>
				<xsl:value-of select="$Years"/>
				<xsl:text>69</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="earlylatestart">
		<xsl:variable name="Fuzzy" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
		<xsl:variable name="MCen" select="string-length($Fuzzy)"/>
		<xsl:variable name="CNS" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
		<xsl:choose>
			<xsl:when test="$MCen = 4">
				<xsl:variable name="century" select="substring($CNS, 1, 2)"/>
				<xsl:variable name="years" select="$century - 1"/>
				<xsl:text>m</xsl:text>
				<xsl:value-of select="$years"/>
				<xsl:text>00</xsl:text>
				<xsl:variable name="Century" select="substring($CNS, 3, 2)"/>
				<xsl:variable name="Years" select="$Century - 1"/>
				<xsl:value-of select="$Years"/>
				<xsl:text>99</xsl:text>
			</xsl:when>	
			<xsl:when test="$MCen = 2">
				<xsl:variable name="century" select="substring($CNS, 1, 2)"/>
				<xsl:variable name="years" select="$century - 1"/>
				<xsl:text>m</xsl:text>
				<xsl:value-of select="$years"/>
				<xsl:text>00</xsl:text>
				<xsl:variable name="Century" select="substring($CNS, 1, 2)"/>
				<xsl:variable name="Years" select="$Century - 1"/>
				<xsl:value-of select="$Years"/>
				<xsl:text>99</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--Templates for dates starting with mid -->
	<xsl:template name="midearlystart">
		<xsl:variable name="Fuzzy" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
		<xsl:variable name="MCen" select="string-length($Fuzzy)"/>
		<xsl:variable name="CNS" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
		<xsl:choose>
			<xsl:when test="$MCen = 4">
				<xsl:variable name="century" select="substring($CNS, 1, 2)"/>
				<xsl:variable name="years" select="$century - 1"/>
				<xsl:text>m</xsl:text>
				<xsl:value-of select="$years"/>
				<xsl:text>30</xsl:text>
				<xsl:variable name="Century" select="substring($CNS, 3, 2)"/>
				<xsl:variable name="Years" select="$Century - 1"/>
				<xsl:value-of select="$Years"/>
				<xsl:text>39</xsl:text>
			</xsl:when>	
			<xsl:when test="$MCen = 2">
				<xsl:variable name="century" select="substring($CNS, 1, 2)"/>
				<xsl:variable name="years" select="$century - 1"/>
				<xsl:text>m</xsl:text>
				<xsl:value-of select="$years"/>
				<xsl:text>30</xsl:text>
				<xsl:variable name="Century" select="substring($CNS, 1, 2)"/>
				<xsl:variable name="Years" select="$Century - 1"/>
				<xsl:value-of select="$Years"/>
				<xsl:text>39</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="midmidstart">
		<xsl:variable name="Fuzzy" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
		<xsl:variable name="MCen" select="string-length($Fuzzy)"/>
		<xsl:variable name="CNS" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
		<xsl:choose>
			<xsl:when test="$MCen = 4">
				<xsl:variable name="century" select="substring($CNS, 1, 2)"/>
				<xsl:variable name="years" select="$century - 1"/>
				<xsl:text>m</xsl:text>
				<xsl:value-of select="$years"/>
				<xsl:text>30</xsl:text>
				<xsl:variable name="Century" select="substring($CNS, 3, 2)"/>
				<xsl:variable name="Years" select="$Century - 1"/>
				<xsl:value-of select="$Years"/>
				<xsl:text>69</xsl:text>
			</xsl:when>	
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="midlatestart">
		<xsl:variable name="Fuzzy" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
		<xsl:variable name="MCen" select="string-length($Fuzzy)"/>
		<xsl:variable name="CNS" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
		<xsl:choose>
			<xsl:when test="$MCen = 4">
				<xsl:variable name="century" select="substring($CNS, 1, 2)"/>
				<xsl:variable name="years" select="$century - 1"/>
				<xsl:text>m</xsl:text>
				<xsl:value-of select="$years"/>
				<xsl:text>30</xsl:text>
				<xsl:variable name="Century" select="substring($CNS, 3, 2)"/>
				<xsl:variable name="Years" select="$Century - 1"/>
				<xsl:value-of select="$Years"/>
				<xsl:text>99</xsl:text>
			</xsl:when>	
			<xsl:when test="$MCen = 2">
				<xsl:variable name="century" select="substring($CNS, 1, 2)"/>
				<xsl:variable name="years" select="$century - 1"/>
				<xsl:text>m</xsl:text>
				<xsl:value-of select="$years"/>
				<xsl:text>30</xsl:text>
				<xsl:variable name="Century" select="substring($CNS, 1, 2)"/>
				<xsl:variable name="Years" select="$Century - 1"/>
				<xsl:value-of select="$Years"/>
				<xsl:text>99</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- dates starting with Late-->
	<xsl:template name="lateearlystart">
		<xsl:variable name="Fuzzy" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
		<xsl:variable name="MCen" select="string-length($Fuzzy)"/>
		<xsl:variable name="CNS" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
		<xsl:choose>
			<xsl:when test="$MCen = 4">
				<xsl:variable name="century" select="substring($CNS, 1, 2)"/>
				<xsl:variable name="years" select="$century - 1"/>
				<xsl:text>m</xsl:text>
				<xsl:value-of select="$years"/>
				<xsl:text>60</xsl:text>
				<xsl:variable name="Century" select="substring($CNS, 3, 2)"/>
				<xsl:variable name="Years" select="$Century - 1"/>
				<xsl:value-of select="$Years"/>
				<xsl:text>39</xsl:text>
			</xsl:when>	
			<xsl:when test="$MCen = 2">
				<xsl:variable name="century" select="substring($CNS, 1, 2)"/>
				<xsl:variable name="years" select="$century - 1"/>
				<xsl:text>m</xsl:text>
				<xsl:value-of select="$years"/>
				<xsl:text>60</xsl:text>
				<xsl:variable name="Century" select="substring($CNS, 1, 2)"/>
				<xsl:variable name="Years" select="$Century - 1"/>
				<xsl:value-of select="$Years"/>
				<xsl:text>39</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="latemidstart">
		<xsl:variable name="Fuzzy" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
		<xsl:variable name="MCen" select="string-length($Fuzzy)"/>
		<xsl:variable name="CNS" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
		<xsl:choose>
			<xsl:when test="$MCen = 4">
				<xsl:variable name="century" select="substring($CNS, 1, 2)"/>
				<xsl:variable name="years" select="$century - 1"/>
				<xsl:text>m</xsl:text>
				<xsl:value-of select="$years"/>
				<xsl:text>60</xsl:text>
				<xsl:variable name="Century" select="substring($CNS, 3, 2)"/>
				<xsl:variable name="Years" select="$Century - 1"/>
				<xsl:value-of select="$Years"/>
				<xsl:text>69</xsl:text>
			</xsl:when>	
			<xsl:when test="$MCen = 2">
				<xsl:variable name="century" select="substring($CNS, 1, 2)"/>
				<xsl:variable name="years" select="$century - 1"/>
				<xsl:text>m</xsl:text>
				<xsl:value-of select="$years"/>
				<xsl:text>60</xsl:text>
				<xsl:variable name="Century" select="substring($CNS, 1, 2)"/>
				<xsl:variable name="Years" select="$Century - 1"/>
				<xsl:value-of select="$Years"/>
				<xsl:text>69</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="latelatestart">
		<xsl:variable name="Fuzzy" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
		<xsl:variable name="MCen" select="string-length($Fuzzy)"/>
		<xsl:variable name="CNS" select="translate(//Date, translate(//Date, '0123456789', ''), '')"/>
		<xsl:choose>
			<xsl:when test="$MCen = 4">
				<xsl:variable name="century" select="substring($CNS, 1, 2)"/>
				<xsl:variable name="years" select="$century - 1"/>
				<xsl:text>m</xsl:text>
				<xsl:value-of select="$years"/>
				<xsl:text>60</xsl:text>
				<xsl:variable name="Century" select="substring($CNS, 3, 2)"/>
				<xsl:variable name="Years" select="$Century - 1"/>
				<xsl:value-of select="$Years"/>
				<xsl:text>99</xsl:text>
			</xsl:when>	
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="CodedAV">
		<xsl:choose>
			<xsl:when test="contains(//Format_Details, 'videocassette')"><xsl:text>vf </xsl:text></xsl:when>
			<xsl:when test="contains(//Format_Details, 'film')"><xsl:text>vr </xsl:text></xsl:when>
			<xsl:otherwise><xsl:text>v| </xsl:text></xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
		<xsl:when test="contains(//Format_Details, 'col')"><xsl:text>c</xsl:text></xsl:when>
		<xsl:when test="contains(//Format_Details, 'b&amp;w')"><xsl:text>b</xsl:text></xsl:when>
		<xsl:otherwise><xsl:text>|</xsl:text></xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="contains(//Format_Details, 'VHS')"><xsl:text>b</xsl:text></xsl:when>
			<xsl:when test="contains(//Format_Details, 'Beta')"><xsl:text>a</xsl:text></xsl:when>
			<xsl:otherwise><xsl:text>|</xsl:text></xsl:otherwise>
		</xsl:choose>
		<xsl:text>||||</xsl:text>
	</xsl:template>
	
</xsl:stylesheet>
