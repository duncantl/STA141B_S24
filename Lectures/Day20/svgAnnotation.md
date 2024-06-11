# Basics of Annotating SVG Plots

The essential steps are

+ Open the graphics device 
   + svglite()
   + svg()

+ Create the R plot in the "regular" way, i.e., any R graphics commands.

+ Close the graphics device
   + dev.off()
   
+ Read the SVG XML content back into R.
   + e.g., xmlParse()

+ Identify the nodes you want to modify
   + Do need to deal with XML namespaces
     +  e.g., `getNodeSet(doc, "//x:circle", "x")`

+ Modify these nodes
   + Add/change attributes
      + `xmlAttrs(node) = c(id = 1, onclick = 'javaScript.code()')`
   + Add child nodes
      + `newXMLNode("title", "text for tooltip", parent = node)`

+ save the update document
   + `saveXML(doc, 'filename.svg')`
   
   

