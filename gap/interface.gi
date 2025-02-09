# Vole: Backtrack search in permutation groups with graphs
# A GAP package by Mun See Chang, Christopher Jefferson, and Wilf A. Wilson.
#
# SPDX-License-Identifier: MPL-2.0
#
# Implementations: The native interface to Vole

VoleFind.Representative := function(arguments...)
    local conf, constraints, bounds, ret, temp;

    if IsEmpty(arguments) then
        ErrorNoReturn("VoleFind.Rep: At least one argument must be given");
    fi;
    conf := _Vole.getConfig(rec(raw := false, points := infinity));
    if IsInt(conf.points) then
        Add(arguments, conf.points);
    fi;
    temp := ProcessConstraints(arguments);
    if temp.is_known_empty then
        return fail;
    fi;

    constraints := Concatenation(temp.refiners, Flat(List(temp.constraints_without_refiners, VoleRefiner.FromConstraint)));
    bounds := _Vole.getBounds(constraints, conf.points, true);
    ret    := _Vole.CosetSolve(Minimum(bounds.min, bounds.max), constraints);

    if conf.raw then
        return ret;
    elif not IsEmpty(ret.sols) then
        return ret.sols[1];
    else
        return fail;
    fi;
end;
VoleFind.Rep := VoleFind.Representative;

VoleFind.Group := function(arguments...)
    local conf, constraints, bounds, ret, temp;

    if IsEmpty(arguments) then
        ErrorNoReturn("VoleFind.Group: At least one argument must be given");
    fi;

    conf        := _Vole.getConfig(rec(raw := false, points := infinity));
    if IsInt(conf.points) then
        Add(arguments, conf.points);
    fi;
    temp := ProcessConstraints(arguments);
    if not temp.is_group then
        ErrorNoReturn("constraints are not all groups");
    fi;
    constraints := Concatenation(temp.refiners, Flat(List(temp.constraints_without_refiners, VoleRefiner.FromConstraint)));
    bounds      := _Vole.getBounds(constraints, conf.points, false);
    ret         := _Vole.GroupSolve(bounds.max, constraints);

    if conf.raw then
        return ret;
    else
        return ret.group;
    fi;
end;

VoleFind.Coset := function(arguments...)
    local conf, constraints, bounds, ret, temp;

    if IsEmpty(arguments) then
        ErrorNoReturn("VoleFind.Coset: At least one argument must be given");
    fi;
    conf := _Vole.getConfig(rec(raw := false, points := infinity));
    if IsInt(conf.points) then
        Add(arguments, conf.points);
    fi;
    temp := ProcessConstraints(arguments);
    if temp.is_known_empty then
        return fail;
    fi;

    constraints := Concatenation(temp.refiners, Flat(List(temp.constraints_without_refiners, VoleRefiner.FromConstraint)));
    bounds := _Vole.getBounds(constraints, conf.points, false);
    ret    := _Vole.CosetSolve(bounds.max, constraints);

    if conf.raw then
        return ret;
    elif ret.cosetrep <> fail then
        return RightCoset(ret.group, ret.cosetrep);
    else
        return fail;
    fi;
end;

VoleFind.Canonical := function(G, arguments...)
    local constraints, conf, bounds, ret;

    if not IsPermGroup(G) then
        ErrorNoReturn("VoleFind.Canonical: ",
                      "The first argument must be a perm group");
    elif IsEmpty(arguments) then
        ErrorNoReturn("VoleFind.Canonical: ",
                      "At least two arguments must be given");
    else
        constraints := Flat(arguments);
    fi;

    if ForAny(constraints, IsPermGroup) then
        # We don't do any interpretation of 'GAP object' arguments into
        # constraints, i.e. we don't assume that a group 'G' corresponds to
        # Constraint.Normalise(G). Maybe we should do this eventually, but for now
        # I am worried that this will lead to confusion, since for
        # VoleFind.Group, an argument 'G' is interpreted as Constraint.InGroup(G).
        ErrorNoReturn("VoleFind.Canonical: ",
                      "A perm group is not valid additional argument; ",
                      "to canonise a group under conjugation, ",
                      "use the constraint Constraint.Normalise, ",
                      "or give a specific normaliser refiner;");

    elif ForAny(constraints, c -> not IsRefiner(c) and not IsConstraint(c) and not (IsRecord(c) and IsBound(c.con))) then
        # Check that the args are refiners/records
        ErrorNoReturn("VoleFind.Canonical: ",
                      "The additional arguments must be Vole constraints, or ",
                      "(potentially custom) Vole, GraphBacktracking, or ",
                      "BacktrackKit refiners;");

    elif ForAny(constraints, c -> IsRefiner(c) and StartsWith(c!.name, "InGroup"))
      or ForAny(constraints, c -> IsConstraint(c) and IsInGroupByGensConstraint(c))
      or ForAny(constraints, c -> IsRecord(c) and IsBound(c.con.InSymmetricGroup))
      then
        # Try to check that no "in-group-by-generators" refiner was been given.
        ErrorNoReturn("VoleFind.Canonical: ",
                      "The additional arguments must not include any ",
                      "constraints/refiners that are ",
                      "(directly or indirectly) of the kind ",
                      "'in-group-given-by-generators'; ",
                      "i.e. Constraint.InGroup(H) and ",
                      "Constraint.LargestMovedPoint(k) are not allowed. ",
                      "To canonise a group under conjugation, ",
                      "use the constraint Constraint.Normalise, ",
                      "or give a specific normaliser refiner. ",
                      "To restrict the moved points, canonise in a different ",
                      "group;");

    elif ForAny(constraints, c -> IsRefiner(c) and not IsGroupConstraint(c!.constraint))
      or ForAny(constraints, c -> IsConstraint(c) and not IsGroupConstraint(c))
      or ForAny(constraints, c -> IsRecord(c) and EndsWith(RecNames(c.con)[1], "Transport"))
      then
        # Try to check for "coset" refiners/constraints
        ErrorNoReturn("VoleFind.Canonical: ",
                      "Each additional argument must be a constraint or ",
                      "refiner for the stabiliser of some object under some ",
                      "group action; constraints/refiners for cosets that are ",
                      "groups are not allowed; Vole 'Transporter' ",
                      "constraints/refiners are not allowed either;");
    fi;

    constraints := Flat(List(constraints, VoleRefiner.FromConstraint));
    conf   := _Vole.getConfig(rec(raw := false, points := infinity));
    bounds := _Vole.getBounds(Concatenation(constraints, [G]), conf.points, false);
    ret    := _Vole.CanonicalSolve(bounds.max, G, constraints);

    if conf.raw then
        return ret;
    else
        return rec(group := ret.group, canonical := ret.canonical);
    fi;
end;

VoleFind.CanonicalPerm := {G, constraints...} ->
    CallFuncList(VoleFind.Canonical, Concatenation([G], constraints)).canonical;
