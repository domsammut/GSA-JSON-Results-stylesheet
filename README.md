gsa-json-ouput-format
=====================
<em>2013 Dom Sammut <a href="http://www.twitter.com/domsammut">@domsammut</a></em>

Google Search Appliance XSL to output results in formatted JSON.

<strong><u>Notes</u></strong>

<ul>
<li>Retains the same structure as the XML source.</li>
<li>Nodes that are empty will have <code>null</code> as a value.</li>
<li>Support for Dynamic Navigation. This can be turned off at line 25 by setting the false to <code>false()</code></li>
</ul>

<strong>To do:</strong>

<ul>
<li>Document Preview support
    <ul>
      <li>Split the XML node into nice chunks and create custom json structure since all the information for document previews is just dumped into a single node</li>
    </ul>
</li>
<li>Option to turn off tab spacing and other structural formatting (to reduce file size slightly)</li>
</ul>
