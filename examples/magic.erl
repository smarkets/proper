-module(magic).
-export([spells/0, cast_spell/2, cast_spells/2]).
-export([run_random/1, run_generated/1, run_handwritten/1, count_spells/1]).


-include_lib("proper/include/proper.hrl").

-record(attr, {strength     = 0 :: integer(),
               constitution = 0 :: integer(),
               defense      = 0 :: integer(),
               dexterity    = 0 :: integer(),
               intelligence = 0 :: integer(),
               charisma     = 0 :: integer(),
               wisdom       = 0 :: integer(),
               willpower    = 0 :: integer(),
               perception   = 0 :: integer(),
               luck         = 0 :: integer()}).

-type attr() :: #attr{}.
-type spell() :: attr().

-spec spells() -> list(spell()).
spells() ->
  [#attr{strength = 5, constitution = -2, defense = 0,  dexterity = -3, intelligence = 0,  charisma = 0,  wisdom = 0,  willpower = 0,  perception = 0,  luck = 0},
   #attr{strength = 0,  constitution = 0,  defense = 4,  dexterity = 0,  intelligence = 0,  charisma = 0,  wisdom = 0,  willpower = -4, perception = 0,  luck = 0},
   #attr{strength = 0,  constitution = 0,  defense = 0,  dexterity = 0,  intelligence = -3, charisma = 1,  wisdom = 1,  willpower = 0,  perception = 1,  luck = 0},
   #attr{strength = 1,  constitution = 2,  defense = 2,  dexterity = 0,  intelligence = 0,  charisma = 0,  wisdom = 0,  willpower = -3, perception = 0,  luck = 0},
   #attr{strength = 0,  constitution = 0,  defense = 0,  dexterity = 0,  intelligence = 1,  charisma = 1,  wisdom = 1,  willpower = -3, perception = 0,  luck = 0},
   #attr{strength = 1,  constitution = 0,  defense = 0,  dexterity = 0,  intelligence = -3, charisma = 0,  wisdom = 0,  willpower = 0,  perception = 0,  luck = 2},
   #attr{strength = 0,  constitution = 0,  defense = 0,  dexterity = 0,  intelligence = 1,  charisma = 1,  wisdom = 1,  willpower = -4, perception = 1,  luck = 0},
   #attr{strength = 0,  constitution = 0,  defense = 0,  dexterity = 0,  intelligence = 0,  charisma = 2,  wisdom = 0,  willpower = 0,  perception = 1,  luck = -3},
   #attr{strength = 2,  constitution = -2, defense = 0,  dexterity = 0,  intelligence = 0,  charisma = 0,  wisdom = 0,  willpower = 0,  perception = 0,  luck = 0},
   #attr{strength = 0,  constitution = 2,  defense = -2, dexterity = 0,  intelligence = 0,  charisma = 0,  wisdom = 0,  willpower = 0,  perception = 0,  luck = 0},
   #attr{strength = 0,  constitution = 0,  defense = 2,  dexterity = -2, intelligence = 0,  charisma = 0,  wisdom = 0,  willpower = 0,  perception = 0,  luck = 0},
   #attr{strength = 0,  constitution = 0,  defense = 0,  dexterity = 2,  intelligence = -2,  charisma = 0,  wisdom = 0,  willpower = 0,  perception = 0,  luck = 0},
   #attr{strength = -1, constitution = -1, defense = -1, dexterity = -1, intelligence = -1, charisma = -1, wisdom = -1, willpower = 10, perception = -1, luck = -1},
   #attr{strength = 0,  constitution = 0,  defense = 0,  dexterity = 0,  intelligence = 2,  charisma = -2, wisdom = 0,  willpower = 0,  perception = 0,  luck = 0},
   #attr{strength = 0,  constitution = 0,  defense = 0,  dexterity = 0,  intelligence = 0,  charisma = 2,  wisdom = -2, willpower = 0,  perception = 0,  luck = 0},
   #attr{strength = 0,  constitution = 0,  defense = 0,  dexterity = 0,  intelligence = 0,  charisma = 0,  wisdom = 2,  willpower = -2, perception = 0,  luck = 0},
   #attr{strength = 0,  constitution = 0,  defense = 0,  dexterity = 0,  intelligence = 0,  charisma = 0,  wisdom = 0,  willpower = 2,  perception = -2, luck = 0},
   #attr{strength = 0,  constitution = 0,  defense = 0,  dexterity = 0,  intelligence = 0,  charisma = 0,  wisdom = 0,  willpower = 0,  perception = 2,  luck = -2},
   #attr{strength = -2,  constitution = 0,  defense = 0,  dexterity = 0,  intelligence = 0,  charisma = 0,  wisdom = 0,  willpower = 0,  perception = 0,  luck = 2},
   #attr{strength = 5,  constitution = 0,  defense = 0,  dexterity = 0,  intelligence = 0,  charisma = 0,  wisdom = 0,  willpower = 0,  perception = 0,  luck = -8}].

%% no penalty for wrongly casted spells
-spec cast_spell(attr(), spell()) -> attr().
cast_spell(Attrs, Spell) ->
  NewAttrs = raw_cast_spell(Attrs, Spell),
  if
    NewAttrs#attr.strength < 0 -> Attrs;
    NewAttrs#attr.constitution < 0 -> Attrs;
    NewAttrs#attr.defense < 0 -> Attrs;
    NewAttrs#attr.dexterity < 0 -> Attrs;
    NewAttrs#attr.intelligence < 0 -> Attrs;
    NewAttrs#attr.charisma < 0 -> Attrs;
    NewAttrs#attr.wisdom < 0 -> Attrs;
    NewAttrs#attr.willpower < 0 -> Attrs;
    NewAttrs#attr.perception < 0 -> Attrs;
    NewAttrs#attr.luck < 0 -> Attrs;
    true -> NewAttrs
  end.

raw_cast_spell(Attrs, Spell) ->
  Attrs#attr{strength     = Attrs#attr.strength     + Spell#attr.strength,
             constitution = Attrs#attr.constitution + Spell#attr.constitution,
             defense      = Attrs#attr.defense      + Spell#attr.defense,
             dexterity    = Attrs#attr.dexterity    + Spell#attr.dexterity,
             intelligence = Attrs#attr.intelligence + Spell#attr.intelligence,
             charisma     = Attrs#attr.charisma     + Spell#attr.charisma,
             wisdom       = Attrs#attr.wisdom       + Spell#attr.wisdom,
             willpower    = Attrs#attr.willpower    + Spell#attr.willpower,
             perception   = Attrs#attr.perception   + Spell#attr.perception,
             luck         = Attrs#attr.luck         + Spell#attr.luck}.

cast_spells(Attrs, []) -> Attrs;
cast_spells(Attrs, [Spell | LeftSpells]) ->
  cast_spells(cast_spell(Attrs, Spell), LeftSpells).

%% Properties
%% ----------
sum_attr(Attrs) ->
  Attrs#attr.strength + Attrs#attr.constitution +
    Attrs#attr.defense + Attrs#attr.dexterity +
    Attrs#attr.intelligence + Attrs#attr.charisma +
    Attrs#attr.wisdom + Attrs#attr.willpower +
    Attrs#attr.perception + Attrs#attr.luck.

list_of_spells() ->
  list(proper_types:noshrink(oneof(spells()))).

prop_spells() ->
  ?FORALL(Spells, list_of_spells(),
          begin
            InitialAttr = #attr{strength     = 5,
                                constitution = 5,
                                defense      = 5,
                                dexterity    = 5,
                                intelligence = 5,
                                charisma     = 5,
                                wisdom       = 5,
                                willpower    = 5,
                                perception   = 5,
                                luck         = 5},
            BuffedAttr = cast_spells(InitialAttr, Spells),
            SumAttr = sum_attr(BuffedAttr),
            ?WHENFAIL(io:format("Number of Spells: ~p~nTotal Attr: ~p~n",
                                [length(Spells), SumAttr]),
                      SumAttr < 2 * sum_attr(InitialAttr))
          end).

prop_spells_gen() ->
  ?FORALL_SA(Spells, ?TARGET(#{gen => list_of_spells()}),
             begin
               InitialAttr = #attr{strength     = 5,
                                   constitution = 5,
                                   defense      = 5,
                                   dexterity    = 5,
                                   intelligence = 5,
                                   charisma     = 5,
                                   wisdom       = 5,
                                   willpower    = 5,
                                   perception   = 5,
                                   luck         = 5},
               BuffedAttr = cast_spells(InitialAttr, Spells),
               SumAttr = sum_attr(BuffedAttr),
               ?MAXIMIZE(SumAttr),
               ?WHENFAIL(io:format("Number of Spells: ~p~nTotal Attr: ~p~n",
                                   [length(Spells), SumAttr]),
                         SumAttr < 2 * sum_attr(InitialAttr))
             end).

prop_spells_hw() ->
  ?FORALL_SA(Spells, ?TARGET(list_of_spells_sa()),
             begin
               InitialAttr = #attr{strength     = 5,
                                   constitution = 5,
                                   defense      = 5,
                                   dexterity    = 5,
                                   intelligence = 5,
                                   charisma     = 5,
                                   wisdom       = 5,
                                   willpower    = 5,
                                   perception   = 5,
                                   luck         = 5},
               BuffedAttr = cast_spells(InitialAttr, Spells),
               SumAttr = sum_attr(BuffedAttr),
               ?MAXIMIZE(SumAttr),
               ?WHENFAIL(io:format("Number of Spells: ~p~nTotal Attr: ~p~n",
                                   [length(Spells), SumAttr]),
                         SumAttr < 2 * sum_attr(InitialAttr))
             end).

list_of_spells_sa() ->
  #{first => list_of_spells(),
    next => list_of_spells_next()}.

list_of_spells_next() ->
  Del = 10,
  Add = 40,
  fun (Base, T) ->
      ?LET(OP, oneof([del_run, add_run]),
           case OP of
             del_run -> delete_some_spells(Base, Del, T);
             add_run -> add_some_spells(Base, Add, T)
           end)
  end.

add_some_spells(Spells, Percentage, _) ->
  NumAdd = max(1, trunc(length(Spells) * Percentage / 100)),
  ?LET(AddIndices, indices(NumAdd, 0, length(Spells)),
       begin
         %% have to be able to inser elements in the front of the list
         {Spells2, AddIndices2} = case AddIndices of
                                    [0 | NormalIndices] ->
                                      {[oneof(spells()) | Spells], NormalIndices};
                                    _ ->
                                      {Spells, AddIndices}
                                  end,
         %% handle rest of the list
         {_, [], NewSpells} = lists:foldl(fun (S, {I, [], Acc}) ->
                                              {I + 1, [], [S | Acc]};
                                              %% next function head
                                              (S, {I, AllIds = [DI |DIs], Acc}) ->
                                              case I =:= DI of
                                                true -> {I + 1, DIs, [S, oneof(spells()) |Acc]};
                                                false -> {I + 1, AllIds, [S | Acc]}
                                              end
                                          end, {1, AddIndices2, []}, Spells2),
         lists:reverse(NewSpells)
       end).

delete_some_spells(Spells, Percentage, _) ->
  NumDel = trunc(length(Spells) * Percentage / 100),
  ?LET(DelIndices, indices(NumDel, 1, length(Spells)),
       begin
         %% make sure that every element in the list can be deleted
         {_, [], NewSpells} = lists:foldl(fun (S, {I, [], Acc}) ->
                                              {I + 1, [], [S | Acc]};
                                              %% next function head
                                              (S, {I, AllDIs = [DI | DIs], Acc}) ->
                                              case I =:= DI of
                                                true -> {I + 1, DIs, Acc};
                                                false -> {I + 1, AllDIs, [S | Acc]}
                                              end
                                          end, {1, DelIndices, []}, Spells),
         lists:reverse(NewSpells)
       end).

indices(Num, Low, High) ->
  indices(Num, Low, High, []).

indices(0, _, _, Acc) -> lists:sort(Acc);
indices(N, Low, High, Acc) ->
  ?LET(I, index(Low, High, Acc),
       ?LAZY(indices(N-1, Low, High, [I | Acc]))).

index(Low, High, Blacklist) ->
  ?SUCHTHAT(I, integer(Low, High), not lists:member(I, Blacklist)).

%% utility functions
run_random(N) ->
  proper:quickcheck(prop_spells(), N).

run_generated(N) ->
  proper:quickcheck(prop_spells_gen(), [{numtests, N}, noshrink]).

run_handwritten(N) ->
  proper:quickcheck(prop_spells_hw(), [{numtests, N}, noshrink]).

count_spells(Spells) ->
  CountedSpells = maps:to_list(count_spells(Spells, #{})),
  lists:sort(fun ({_, A},{_, B}) -> A > B end, CountedSpells).

count_spells([], Acc) -> Acc;
count_spells([H|T], Acc) ->
  NewAcc = case Acc of
             #{H := Count} -> Acc#{H => Count + 1};
             _ -> Acc#{H => 1}
           end,
  count_spells(T, NewAcc).
