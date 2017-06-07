xquery version "3.0";
declare namespace mods = "http://www.loc.gov/mods/v3";
declare namespace drb = "http://www.dartmouth.edu/~library/catmet/";
declare option saxon:output "method=text";
declare variable $location external := '.';

let $source := collection(concat($location, '?select=*-mods.xml'))
for $doc in $source
let $mods-filename := tokenize(document-uri($doc), '/')[last()]
let $master-filename := string-join($doc/mods:mods/mods:extension/drb:filename[@type = 'master'], ',')
return (text{$mods-filename}, text{','}, text{$master-filename}, text{'&#xA;'})