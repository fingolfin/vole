# Vole, chapter 4
#
# DO NOT EDIT THIS FILE - EDIT EXAMPLES IN THE SOURCE INSTEAD!
#
# This file has been generated by AutoDoc. It contains examples extracted from
# the package documentation. Each example is preceded by a comment which gives
# the name of a GAPDoc XML file and a line range from which the example were
# taken. Note that the XML file in turn may have been generated by AutoDoc
# from some other input.
#
gap> START_TEST("vole04.tst");

# doc/_Chapter_wrapper.xml:96-104
gap> LoadPackage("vole", false);;
gap> Set(RecNames(Vole));
[ "AutomorphismGroup", "CanonicalDigraph", "CanonicalImage", 
  "CanonicalImagePerm", "CanonicalPerm", "Centraliser", "Centralizer", 
  "DigraphCanonicalLabelling", "Intersection", "IsConjugate", 
  "IsIsomorphicDigraph", "IsomorphismDigraphs", "Normaliser", "Normalizer", 
  "RepresentativeAction", "Stabiliser", "Stabilizer", "TwoClosure" ]

# doc/_Chapter_wrapper.xml:235-244
gap> A6 := AlternatingGroup(6);;
gap> D12 := DihedralGroup(IsPermGroup, 12);;
gap> Vole.Intersection(A6, D12);
Group([ (2,6)(3,5), (1,3,5)(2,4,6) ])
gap> Vole.Intersection(A6 * (1,2), D12 * (3,4));
RightCoset(Group([ (2,6)(3,5), (1,3)(4,6) ]),(1,5,4,2,6,3))
gap> Vole.Intersection(A6 * (1,2), D12 * (3,4), PSL(2,5));
[  ]

# doc/_Chapter_wrapper.xml:277-287
gap> Vole.Stabiliser(PGL(2,5), [1,2,3], OnSets);
Group([ (1,3)(5,6), (1,2,3)(4,5,6) ])
gap> D := JohnsonDigraph(4,2);;
gap> G := Stabiliser(PSL(2,5), D, OnDigraphs);;
gap> G = Group([ (1,4,5)(2,6,3), (1,4)(3,6) ]);
true
gap> Elements(G)
>  = SortedList(Filtered(PSL(2,5), g -> OnDigraphs(D, g) = D));
true

# doc/_Chapter_wrapper.xml:322-330
gap> Vole.RepresentativeAction(SymmetricGroup(4), (1,2,3), (1,2,4));
(1,4,3,2)
gap> RepresentativeAction(AlternatingGroup(4), (1,2,3), (1,2,4));
fail
gap> D := CycleDigraph(6);;
gap> Vole.RepresentativeAction(PGL(2,5), D, DigraphReverse(D), OnDigraphs);
(1,4)(2,3)(5,6)

# doc/_Chapter_wrapper.xml:360-366
gap> Vole.Normaliser(SymmetricGroup(6), PSL(2,5)) = PGL(2,5);
true
gap> D12 := DihedralGroup(IsPermGroup, 12);;
gap> Vole.Normaliser(SymmetricGroup(6), (1,2,3,4,5,6)) = D12;
true

# doc/_Chapter_wrapper.xml:390-395
gap> Vole.Centraliser(MathieuGroup(12), (1,11,9,4,3,2)(5,7,8,6,12,10));
Group([ (1,2,3,4,9,11)(5,10,12,6,8,7), (1,5,3,12,9,8)(2,10,4,6,11,7) ])
gap> Vole.Centraliser(Group((1,2,3,4,5,6)), DihedralGroup(IsPermGroup, 12));
Group([ (1,4)(2,5)(3,6) ])

# doc/_Chapter_wrapper.xml:428-437
gap> # Conjugacy of permutations
gap> x := (1,2,3,4,5);; y := (1,2,3,4,6);;
gap> Vole.IsConjugate(SymmetricGroup(6), x, y);
true
gap> Vole.IsConjugate(AlternatingGroup(6), x, y);
false
gap> Vole.IsConjugate(Group([ (5,6) ]), x, y);
true

# doc/_Chapter_wrapper.xml:441-450
gap> x := Group([ (1,2,3,4,5) ]);;
gap> y := Group([ (1,2,3,4,6) ]);;
gap> Vole.IsConjugate(SymmetricGroup(6), x, y);
true
gap> Vole.IsConjugate(Group([ (1,2)(3,4) ]), x, y);
false
gap> Vole.IsConjugate(Group([ (5,6) ]), x, y);
true

# doc/_Chapter_wrapper.xml:480-487
gap> LoadPackage("orbitalgraphs", false);;
gap> G := Group([ (1,4)(2,5), (1,3,5)(2,4,6) ]);;  # A4 on six points
gap> (3,6) in G;
false
gap> Vole.TwoClosure(G) = ClosureGroup(G, (3,6));
true

# doc/_Chapter_wrapper.xml:560-563
gap> Vole.CanonicalPerm(PSL(2,5), JohnsonDigraph(4,2), OnDigraphs);
(1,2,6)(3,4,5)

# doc/_Chapter_wrapper.xml:602-611
gap> tuple1 := [1,2,3,4];; tuple2 := [1,2,3,5];; tuple3 := [1,5,2,3];;
gap> A5 := AlternatingGroup(5);;
gap> Vole.CanonicalImage(A5, tuple1, OnTuples);
[ 5, 4, 3, 2 ]
gap> Vole.CanonicalImage(A5, tuple2, OnTuples);
[ 4, 5, 3, 2 ]
gap> Vole.CanonicalImage(A5, tuple3, OnTuples);
[ 4, 5, 3, 2 ]

# doc/_Chapter_wrapper.xml:616-623
gap> Vole.RepresentativeAction(A5, tuple1, tuple2, OnTuples);
fail
gap> Vole.RepresentativeAction(A5, tuple1, tuple3, OnTuples);
fail
gap> Vole.RepresentativeAction(A5, tuple2, tuple3, OnTuples);
(2,5,3)

# doc/_Chapter_wrapper.xml:719-722
gap> Vole.AutomorphismGroup(JohnsonDigraph(4,2));
Group([ (3,4), (2,3,5,4), (1,2,6,5)(3,4) ])

# doc/_Chapter_wrapper.xml:752-755
gap> Vole.DigraphCanonicalLabelling(JohnsonDigraph(4,2));
(1,2,4,5,3,6)

# doc/_Chapter_wrapper.xml:782-785
gap> Vole.CanonicalDigraph(JohnsonDigraph(4,2));
<immutable digraph with 6 vertices, 24 edges>

# doc/_Chapter_wrapper.xml:809-815
gap> D := CycleDigraph(6);;
gap> Vole.IsIsomorphicDigraph(D, DigraphReverse(D));
true
gap> Vole.IsIsomorphicDigraph(D, DigraphDual(D));
false

# doc/_Chapter_wrapper.xml:843-849
gap> D := CycleDigraph(6);;
gap> Vole.IsomorphismDigraphs(D, DigraphReverse(D));
(1,4)(2,3)(5,6)
gap> Vole.IsomorphismDigraphs(D, DigraphDual(D));
fail

#
gap> STOP_TEST("vole04.tst", 1);
