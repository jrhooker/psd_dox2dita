TITLE="Switchtec_API"
DITAMAP="Switchtec_API"
PRO="Switchtec"

rm -rf ../out
mkdir ../out

rm -rf ../in/
mkdir ../in/ 

mkdir ../tmp

rm -rf ../tmp/out
mkdir ../tmp/out

cp ../Source/Switchtec/html/*.svg ../out/
cp ../depend/dtds/*.* ../out/

cd ../

WORKINGDIR=$PWD

OUTPUTDIR=$PWD/tmp/out/


cd batchfiles

java -jar ../saxonhe9-3-0-4j/saxon9he.jar -o:../in/index1.xml 

java -jar ../saxonhe9-3-0-4j/saxon9he.jar  -o:../in/index1.xml ../Source/Switchtec/xml/index.xml ../Source/Switchtec/xml/combine.xslt

java -jar ../saxonhe9-3-0-4j/saxon9he.jar  -o:../in/index2.xml ../in/index1.xml ../depend/pmc_custom/process-heirarchy.xsl

java -jar ../saxonhe9-3-0-4j/saxon9he.jar  -o:../in/index3.xml ../in/index2.xml ../depend/pmc_custom/create-heirarchy.xsl heading-level="1"

java -jar ../saxonhe9-3-0-4j/saxon9he.jar  -o:../in/index4.xml ../in/index3.xml ../depend/pmc_custom/create-heirarchy.xsl heading-level="2"

java -jar ../saxonhe9-3-0-4j/saxon9he.jar  -o:../in/index5.xml ../in/index4.xml ../depend/pmc_custom/create-heirarchy.xsl heading-level="3"

java -jar ../saxonhe9-3-0-4j/saxon9he.jar  -o:../in/index6.xml ../in/index5.xml ../depend/pmc_custom/create-heirarchy.xsl heading-level="4"

java -jar ../saxonhe9-3-0-4j/saxon9he.jar  -o:../out/$DITAMAP.ditamap ../in/index6.xml ../depend/pmc_custom/generate_generic_bookmap.xsl title=$TITLE

echo Bookmap Generated

java -jar ../saxonhe9-3-0-4j/saxon9he.jar  -o:../out/trashme.xml ../in/index6.xml ../depend/pmc_custom/generate_topics_DITA_1.0.xsl

java -jar ../saxonhe9-3-0-4j/saxon9he.jar  -o:../out/out.xml ../out/$DITAMAP.ditamap ../depend/pmc_custom/harvest_ids.xsl

echo OUTPUTDIR: $OUTPUTDIR

java -jar ../saxonhe9-3-0-4j/saxon9he.jar  -o:../out/trashme2.xml ../out/$DITAMAP.ditamap ../depend/pmc_custom/rewrite_hrefs.xsl outputdir=$OUTPUTDIR 

echo Topics Generated

cp -rf /home/jeff-linux/Documents/psd_dox2dita/tmp/out/*.* /home/jeff-linux/Documents/psd_dox2dita/out/

echo OUTPUTDIR: $OUTPUTDIR
echo WORKINGDIR: $WORKINGDIR
