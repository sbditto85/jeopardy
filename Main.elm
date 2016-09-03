module Main exposing (..)

import Debug
import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Time exposing (Time)

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
    , hint : String
    , question : String
    , context : String
    , points : Points
    , show : Bool
    }

type alias Team =
    { name : String
    , score : Int
    }

type TimerReason
    = RanOut
    | Answered
    
type Timer
    = Timing Time
    | Done TimerReason

type alias Model =
    { columns : List (ID, Column)
    , teams : List (ID, Team)
    , displayAnswer : Maybe (Answer, ID, ID)
    , showQuestion : Bool
    , currentTeam : ID
    , timer : Timer
    }

type Outcome
    = Right
    | Wrong

type Msg
    = NoOp
    | ShowAnswer Answer ID ID
    | RecordResponse Answer ID ID Outcome
    | ShowQuestion
    | HeartBeat Time

{- INIT -}
initModel =
    let
        columns : List (ID, Column)
        columns = [ (0, { answers = [ (0, { answer = "I broke my bow then made a new one without loosing faith."
                                          , hint = "1 nephi"
                                          , question = "Who is Nephi?"
                                          , context = "1 nephi"
                                          , points = 100
                                          , show = True
                                          })
                                    , (1, { answer = "the game im not making 0.1"
                                          , hint = "hint"
                                          , question = "dont know anything 0.1"
                                          , context = ""
                                          , points = 200
                                          , show = True
                                          })
                                    , (2, { answer = "the game im not making 0.2"
                                          , hint = "hint"
                                          , question = "dont know anything 0.2"
                                          , context = ""
                                          , points = 300
                                          , show = True
                                          })
                                    , (3, { answer = "the game im not making 0.3"
                                          , hint = "hint"
                                          , question = "dont know anything 0.3"
                                          , context = ""
                                          , points = 400
                                          , show = True
                                          })
                                    , (4, { answer = "the game im not making 0.4"
                                          , hint = "hint"
                                          , question = "dont know anything 0.4"
                                          , context = ""
                                          , points = 500
                                          , show = True
                                          })
                                    ]
                        , label = "Nephites"
                        })
                  , (1, { answers = [ (0, { answer = "the game im not making 1.0"
                                          , hint = "hint"
                                          , question = "dont know anything 1.0"
                                          , context = ""
                                          , points = 100
                                          , show = True
                                          })
                                    , (1, { answer = "the game im not making 1.1"
                                          , hint = "hint"
                                          , question = "dont know anything 1.1"
                                          , context = ""
                                          , points = 200
                                          , show = True
                                          })
                                    , (2, { answer = "the game im not making 1.2"
                                          , hint = "hint"
                                          , question = "dont know anything 1.2"
                                          , context = ""
                                          , points = 300
                                          , show = True
                                          })
                                    , (3, { answer = "the game im not making 1.3"
                                          , hint = "hint"
                                          , question = "dont know anything 1.3"
                                          , context = ""
                                          , points = 400
                                          , show = True
                                          })
                                    , (4, { answer = "the game im not making 1.4"
                                          , hint = "hint"
                                          , question = "dont know anything 1.4"
                                          , context = ""
                                          , points = 500
                                          , show = True
                                          })
                                    ]
                        , label = "Lamanites"
                        })
                  , (2, { answers = [ (0, { answer = "the game im not making 2.0"
                                          , hint = "hint"
                                          , question = "dont know anything 2.0"
                                          , context = ""
                                          , points = 100
                                          , show = True
                                          })
                                    , (1, { answer = "the game im not making 2.1"
                                          , hint = "hint"
                                          , question = "dont know anything 2.1"
                                          , context = ""
                                          , points = 200
                                          , show = True
                                          })
                                    , (2, { answer = "the game im not making 2.2"
                                          , hint = "hint"
                                          , question = "dont know anything 2.2"
                                          , context = ""
                                          , points = 300
                                          , show = True
                                          })
                                    , (3, { answer = "the game im not making 2.3"
                                          , hint = "hint"
                                          , question = "dont know anything 2.3"
                                          , context = ""
                                          , points = 400
                                          , show = True
                                          })
                                    , (4, { answer = "the game im not making 2.4"
                                          , hint = "hint"
                                          , question = "dont know anything 2.4"
                                          , context = ""
                                          , points = 500
                                          , show = True
                                          })
                                    ]
                        , label = "Batman"
                        })
                  , (3, { answers = [ (0, { answer = "the game im not making 3.0"
                                          , hint = "hint"
                                          , question = "dont know anything 3.0"
                                          , context = ""
                                          , points = 100
                                          , show = True
                                          })
                                    , (1, { answer = "the game im not making 3.1"
                                          , hint = "hint"
                                          , question = "dont know anything 3.1"
                                          , context = ""
                                          , points = 200
                                          , show = True
                                          })
                                    , (2, { answer = "the game im not making 3.2"
                                          , hint = "hint"
                                          , question = "dont know anything 3.2"
                                          , context = ""
                                          , points = 300
                                          , show = True
                                          })
                                    , (3, { answer = "the game im not making 3.3"
                                          , hint = "hint"
                                          , question = "dont know anything 3.3"
                                          , context = ""
                                          , points = 400
                                          , show = True
                                          })
                                    , (4, { answer = "the game im not making 3.4"
                                          , hint = "hint"
                                          , question = "dont know anything 3.4"
                                          , context = ""
                                          , points = 500
                                          , show = True
                                          })
                                    ]
                        , label = "Free"
                        })
                  ]

        teams : List (ID, Team)
        teams = [ (0, { name = "Boys"
                  , score = 0
                  })
                , (1, { name = "Girls"
                  , score = 0
                  })
                ]
     in
         { columns = columns
         , teams = teams
         , displayAnswer = Nothing
         , showQuestion = False
         , currentTeam = 0
         , timer = Timing (Time.second * 0)
         } ! []

{- UPDATE -}
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        NoOp ->
            model ! []

        ShowAnswer answer cId aId ->
            { model | displayAnswer = Just (answer, cId, aId), timer = Timing (Time.second * 60) } ! []

        ShowQuestion ->
            case model.timer of
                Done RanOut ->
                    { model | showQuestion = True, timer = Done RanOut } ! []

                _ ->
                    { model | showQuestion = True, timer = Done Answered } ! []

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
                        { model | showQuestion = False, displayAnswer = Nothing, columns = columns', currentTeam = currentTeam', teams = teamsWithPoints } ! []

                    Wrong ->
                        { model | showQuestion = False, displayAnswer = Nothing, columns = columns', currentTeam = currentTeam' } ! []

        HeartBeat time ->
            case model.timer of
                Timing time ->
                    if time > Time.second * 0 then
                        { model | timer = (Timing (time - Time.second))} ! []
                    else
                        { model | timer = Done RanOut } ! []
                Done _ ->
                    model ! []

{- VIEW -}
view : Model -> Html Msg
view model =
    let
        grid =
            div []
                [ h1 [] [ text "Jeopardy" ]
                , viewColumns model.columns
                ,  viewTeams model.currentTeam model.teams
                ]

        answer ans cId aId =
            let
                showAnswer =
                    div [ id "answer" ]
                        [ text ans.answer
                        , br [] []
                        , button [ type' "button"
                                 , onClick ShowQuestion
                                 ] [ text "Show Question" ]
                        , viewTimer model
                        ] 

                showQuestion =
                    let
                        buttons =
                            case model.timer of
                                Done RanOut ->
                                    [ button [ type' "button"
                                             , onClick (RecordResponse ans cId aId Wrong)
                                             ] [ text "To slow" ]
                                    ]

                                _ ->
                                    [ button [ type' "button"
                                             , onClick (RecordResponse ans cId aId Right)
                                             ] [ text "Right" ]
                                    , button [ type' "button"
                                             , onClick (RecordResponse ans cId aId Wrong)
                                             ] [ text "Wrong" ]
                                    ]
                    in
                        div [ id "question" ]
                            ([ text ans.question
                            , br [] []
                            , text ans.context
                            , br [] []
                            ] ++ buttons)
                    
            in
                if model.showQuestion then
                    showQuestion
                else
                    showAnswer
                    
    in
        case model.displayAnswer of
            Just (a, cId, aId) ->
                div [] [ answer a cId aId
                       -- , text (toString model)
                       ]

            Nothing ->
                div [] [ grid
                       -- , text (toString model)
                       ]

viewTimer : Model -> Html Msg
viewTimer model =
    case model.timer of
        Timing time ->
            div [ id "timer" ] [ text (toString (Time.inSeconds time)) ]

        Done _ ->
            div [ id "timer" ] [ text "... ran out of time." ]
                    
viewColumns : List (ID, Column) -> Html Msg
viewColumns columns =
    let
        colToHtml (cId, col) =
            let
                answerToHtml (aId, answer) =
                    if answer.show then
                        li [ onClick (ShowAnswer answer cId aId)
                           , class "answer" 
                           ] [ text (toString answer.points) ]
                    else
                        li [ class "answer done"
                           ] [ text (toString answer.points) ]
                
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

viewTeams : ID -> List (ID, Team) -> Html Msg
viewTeams currentTeam teams =
    let
        teamToHtml : (ID, Team) -> Html Msg
        teamToHtml (id, team) =
            li [ classList [("myturn", currentTeam == id)] ]
                [ h2 [] [ text team.name ]
                , span [ class "score" ] [ text (toString team.score) ]
                ]

        teamsHtml : List (Html Msg)
        teamsHtml =
            teams
            |> List.map teamToHtml
    in
        ul [ class "teamContainer" ] teamsHtml


{- SUBSCRIPTIONS -}
heartbeat : Model -> Sub Msg
heartbeat model =
    Time.every Time.second HeartBeat

{- MAIN -}
main =
    App.program { init = initModel
                , view = view
                , update = update
                , subscriptions = heartbeat
                }
    
