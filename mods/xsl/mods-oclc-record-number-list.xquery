xquery version "3.0";
declare namespace mods = "http://www.loc.gov/mods/v3";
declare option saxon:output "method=text";
declare variable $location external := '.';

let $source := collection(concat($location, '?select=*-mods.xml'))
for $doc in $source
let $oclc-record-number := $doc/mods:mods/mods:recordInfo/mods:recordIdentifier[@source='OCoLC']
return (text{$oclc-record-number}, text{'&#xA;'})