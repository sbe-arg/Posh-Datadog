Function Test-DatadogTagName {
  <#
    This function takes a text string for a potential metric name,
    tag name or tag string and formats it to remove any invalid characters using regular expressions.
    Is an utility for making sure any tags,metrics or tag strings won.t.contain.invalid.characters.

    TAG FORMATTING
    Test-DatadogTagName -text 'tag1,tag2,invalid+@#`(*|@#$&tag,tag4=**wrong' -type "tagstring"
    Test-DatadogTagName -text 'Bytes Sent/sec' -type "metric"
    Test-DatadogTagName -text 'My Name With Spaces' -type "tag"

    returns:
    tag1,tag2,invalid.tag,tag4=.wrong
    Bytes.Sent.sec
    My.Name.With.Spaces
  #>
    param(
      [parameter(Mandatory = $true)][string]$text,
      [parameter(Mandatory = $true)][string]$type
    )
    if ($type -eq "metric") {
      # Metric names must start with a letter, and after that may contain ascii alphanumerics, underscore and periods.
      $tmpString = $text -replace "[^a-zA-Z0-9\._]" , "."
    }
    elseif ($type -eq "tagstring") {
      # Tags must start with a letter, and after that may contain alphanumerics, underscores, minuses, colons, periods and slashes
      # assume this is a string of tags as tag or tag:value
      # tag strings could contain :
      $tmpString = $text -replace "[^a-zA-Z0-9\.\\/_=,:-]" , "."
    }
    else {
      # Tags must start with a letter, and after that may contain alphanumerics, underscores, minuses, colons, periods and slashes
      # formatting as a single tag
      $tmpString = $text -replace "[^a-zA-Z0-9\.\\/_-]" , "."
    }
    # remove potential double dots that can occur
    $tmpString -replace "\.{2,}" , "."
}
