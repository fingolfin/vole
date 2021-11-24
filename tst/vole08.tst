# Vole, chapter 8
#
# DO NOT EDIT THIS FILE - EDIT EXAMPLES IN THE SOURCE INSTEAD!
#
# This file has been generated by AutoDoc. It contains examples extracted from
# the package documentation. Each example is preceded by a comment which gives
# the name of a GAPDoc XML file and a line range from which the example were
# taken. Note that the XML file in turn may have been generated by AutoDoc
# from some other input.
#
gap> START_TEST("vole08.tst");

# doc/_Chapter_expert.xml:46-48
gap> LoadPackage("vole", false);;

# doc/_Chapter_expert.xml:117-123
gap> D := PetersenGraph();;
gap> constraint := VoleCon.Stabilise(D, OnDigraphs);;
gap> G := VoleFind.Group(constraint : points := DigraphNrVertices(D));;
gap> [NrMovedPoints(G), TransitiveIdentification(G)];
[ 10, 13 ]

#
gap> STOP_TEST("vole08.tst", 1);
