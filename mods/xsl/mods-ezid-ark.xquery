xquery version "3.0";
declare namespace mods = "http://www.loc.gov/mods/v3";
declare option saxon:output "method=text";
declare variable $location external := '.';

(: Variables for later use :)
let $name-string := if (/mods:mods/mods:name[1]/@type = 'personal') then
   normalize-space(string-join(/mods:mods/mods:name[1]/*[not(ancestor-or-self::mods:role)], ', '))
else
   normalize-space(string-join(/mods:mods/mods:name[1]/*[not(ancestor-or-self::mods:role)], '. '))

let $host-title := if (/mods:mods/mods:relatedItem[@type = 'host']) then
   normalize-space(string-join(/mods:mods/mods:relatedItem[@type = 'host']/mods:titleInfo[not(@type)]))
else
   text {'(:unap)'}
   
(: Put identifier in header comment for update operation :)
let $header := if (/mods:mods/mods:identifier[@type = 'ark']) then
   concat(text {'# '}, substring-after(/mods:mods/mods:identifier[@type = 'ark'], 'https://n2t.net/'), text {'&#xA;'})
else
   ''
   
(: Assemble metadata values :)
let $profile := concat(text {'_profile: '}, text {'dc'})
let $status := concat(text {'_status: '}, text {'public'})
let $target := concat(text {'_target: '}, /mods:mods/mods:location/mods:url[@usage = 'primary'])
let $title := concat(text {'dc.title: '}, normalize-space(string-join(/mods:mods/mods:titleInfo[not(@type)])))
let $name := concat(if (/mods:mods/mods:name[@usage]) then
   text {'dc.creator: '}
else
   text {'dc.contributor: '}, $name-string)
let $publisher := concat(text {'dc.publisher: '}, /mods:mods/mods:originInfo/mods:publisher)
let $date := concat(text {'dc.date: '}, /mods:mods/mods:originInfo/*[@keyDate])
let $identifier := concat(text {'dc.identifier: '}, /mods:mods/mods:recordInfo/mods:recordIdentifier[@source = 'DRB'])
let $host := concat(text {'dc.relation: '}, $host-title)

(: Output metadata file :)
return
   (concat($header, string-join(($profile, $status, $target, $title, $name, $publisher, $date, $identifier, $host), text {'&#xA;'})))