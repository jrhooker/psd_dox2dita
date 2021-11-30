set title="Switchtec API"
set ditamap=Switchtec_API

set WORKINGDIR=%CD%

rmdir %WORKINGDIR%\in /s /q
mkdir %WORKINGDIR%\in

rmdir %WORKINGDIR%\out /s /q

mkdir %WORKINGDIR%\out

copy %WORKINGDIR%\Source\Saragtoga\html\*.svg %WORKINGDIR%\out\ /Y

copy %WORKINGDIR%\depend\dtds\*.* %WORKINGDIR%\out\ /Y

cd ..\

set WORKINGDIR=%CD%

java -jar %WORKINGDIR%\saxonhe9-3-0-4j\saxon9he.jar  -o:%WORKINGDIR%\in\index1.xml %WORKINGDIR%\Source\Switchtec\xml\index.xml %WORKINGDIR%\Source\Switchtec\xml\combine.xslt

java -jar %WORKINGDIR%\saxonhe9-3-0-4j\saxon9he.jar  -o:%WORKINGDIR%\in\index2.xml %WORKINGDIR%\in\index1.xml %WORKINGDIR%\depend\pmc_custom\process-heirarchy.xsl

java -jar %WORKINGDIR%\saxonhe9-3-0-4j\saxon9he.jar  -o:%WORKINGDIR%\in\index3.xml %WORKINGDIR%\in\index2.xml %WORKINGDIR%\depend\pmc_custom\create-heirarchy.xsl heading-level="1"

java -jar %WORKINGDIR%\saxonhe9-3-0-4j\saxon9he.jar  -o:%WORKINGDIR%\in\index4.xml %WORKINGDIR%\in\index3.xml %WORKINGDIR%\depend\pmc_custom\create-heirarchy.xsl heading-level="2"

java -jar %WORKINGDIR%\saxonhe9-3-0-4j\saxon9he.jar  -o:%WORKINGDIR%\in\index5.xml %WORKINGDIR%\in\index4.xml %WORKINGDIR%\depend\pmc_custom\create-heirarchy.xsl heading-level="3"

java -jar %WORKINGDIR%\saxonhe9-3-0-4j\saxon9he.jar  -o:%WORKINGDIR%\in\index6.xml %WORKINGDIR%\in\index5.xml %WORKINGDIR%\depend\pmc_custom\create-heirarchy.xsl heading-level="4"

java -jar %WORKINGDIR%\saxonhe9-3-0-4j\saxon9he.jar  -o:%WORKINGDIR%\out\%ditamap%.ditamap %WORKINGDIR%\in\index6.xml %WORKINGDIR%\depend\pmc_custom\generate_generic_bookmap.xsl title=%title%

echo Bookmap Generated

java -jar %WORKINGDIR%\saxonhe9-3-0-4j\saxon9he.jar  -o:%WORKINGDIR%\out\trashme.xml %WORKINGDIR%\in\index6.xml %WORKINGDIR%\depend\pmc_custom\generate_topics_DITA_1.0.xsl

java -jar %WORKINGDIR%\saxonhe9-3-0-4j\saxon9he.jar  -o:%WORKINGDIR%\out\out.xml %WORKINGDIR%\out\%ditamap%.ditamap %WORKINGDIR%\depend\pmc_custom\harvest_ids.xsl

java -jar %WORKINGDIR%\saxonhe9-3-0-4j\saxon9he.jar  -o:%WORKINGDIR%\out\trashme2.xml %WORKINGDIR%\out\%ditamap%.ditamap %WORKINGDIR%\depend\pmc_custom\rewrite_hrefs.xsl


copy c:\tmp\out\*.* %WORKINGDIR%\out\ /Y

echo Topics Generated

cd %WORKINGDIR%\batchfiles