module Main exposing (..)

import Debug
import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)

{- TYPES -}

type alias Points = Int

type alias ID = Int

type alias ShowAnswer = Bool

type alias Column =
    { answers : List (ID, Answer)
    , label : String
    }

type alias Answer =
    { answer : String
    , question : String
    , points : Points
    , show : Bool
    }

type alias Team =
    { name : String
    , score : Int
    }

type alias Model =
    { columns : List (ID, Column)
    , teams : List (ID, Team)
    , displayAnswer : Maybe (Answer, ID, ID)
    , currentTeam : ID
    }

type Outcome
    = Right
    | Wrong

type Msg
    = NoOp
    | ShowAnswer Answer ID ID
    | RecordResponse Answer ID ID Outcome

{- INIT -}
initModel =
    let
        columns : List (ID, Column)
        columns = [ (0, { answers = [ (0, { answer = "the game im not making"
                                          , question = "dont know anything"
                                          , points = 100
                                          , show = True
                                          })
                                    ]
                        , label = "Init"
                        })
                  , (1, { answers = [ (0, { answer = "the game im not making 2"
                                          , question = "dont know anything 2"
                                          , points = 100
                                          , show = True
                                          })
                                    ]
                        , label = "Init 2"
                        })
                  ]

        teams : List (ID, Team)
        teams = [ (0, { name = "Team 1"
                  , score = 0
                  })
                , (1, { name = "Team 2"
                  , score = 0
                  })
                ]
     in
         { columns = columns
         , teams = teams
         , displayAnswer = Nothing
         , currentTeam = 0
         }

{- UPDATE -}
update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        ShowAnswer answer cId aId ->
            { model | displayAnswer = Just (answer, cId, aId) }

        RecordResponse answer cId aId outcome ->
            let
                maxTeams =
                    List.length model.teams

                teamsWithPoints =
                    model.teams
                        |> List.map (\(id, t) -> if id == model.currentTeam then (id,{ t | score = t.score + answer.points }) else (id,t))

                currentTeam' = if model.currentTeam + 1 == maxTeams then 0 else model.currentTeam + 1

                modAns (aId', a) =
                    if aId' == aId then
                        (aId', { a | show = False })
                    else
                        (aId',a)
                               
                modCol (cId', c) =
                    if cId' == cId then
                        let
                            c' = {c | answers = (List.map modAns c.answers) }
                        in
                            (cId', c')
                    else
                        (cId', c)
                               
                columns' =
                    model.columns
                        |> List.map modCol
            in
                case outcome of
                    Right ->
                        { model | displayAnswer = Nothing, columns = columns', currentTeam = currentTeam', teams = teamsWithPoints }

                    Wrong ->
                        { model | displayAnswer = Nothing, columns = columns', currentTeam = currentTeam' }

{- VIEW -}
view : Model -> Html Msg
view model =
    let
        grid =
            div []
                [ h1 [] [ text "Jeporady" ]
                , viewColumns model.columns
                , viewTeams model.teams
                ]

        answer ans cId aId =
            div []
                [ text ans.answer
                , input [ type' "hidden"
                        , name "question"
                        , value (Debug.log "question" ans.question)
                        ] []
                , button [ type' "button"
                         , onClick (RecordResponse ans cId aId Right)
                         ] [ text "Right" ]
                , button [ type' "button"
                         , onClick (RecordResponse ans cId aId Wrong)
                         ] [ text "Wrong" ]
                ]
                      
    in
        case model.displayAnswer of
            Just (a, cId, aId) ->
                answer a cId aId

            Nothing ->
                grid

viewColumns : List (ID, Column) -> Html Msg
viewColumns columns =
    let
        colToHtml (cId, col) =
            let
                answerToHtml (aId, answer) =
                    if answer.show then
                        li [ onClick (ShowAnswer answer cId aId) ] [ text (toString answer.points) ]
                    else
                        li [ ] [ text "" ]
                
                answers =
                    col.answers
                    |> List.map answerToHtml
            in
                li []
                    [ div []
                          [ h2 [] [ text col.label ]
                          , ul [] answers
                          ]
                    ]

        cols =
            columns
            |> List.map colToHtml
    in
        ul [ class "colContainer" ] cols

viewTeams : List (ID, Team) -> Html Msg
viewTeams teams =
    let
        teamToHtml : (ID, Team) -> Html Msg
        teamToHtml (id, team) =
            li []
                [ h2 [] [ text team.name ]
                , text (toString team.score)
                ]

        teamsHtml : List (Html Msg)
        teamsHtml =
            teams
            |> List.map teamToHtml
    in
        ul [ class "teamContainer" ] teamsHtml


{- MAIN -}
main =
    App.beginnerProgram { model = initModel
                     , view = view
                     , update = update
                     }
    
