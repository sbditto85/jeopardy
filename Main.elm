module Main exposing (..)

-- import Debug
import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Jeopardy.Types exposing (..)
import Jeopardy.Init exposing (initModel)
import Time exposing (Time)


{- UPDATE -}
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        NoOp ->
            model ! []

        ShowAnswer answer cId aId ->
            { model | displayAnswer = Just (answer, cId, aId), timer = Timing (Time.minute * 4) } ! []

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
                hint' =
                    case model.timer of
                        Timing time ->
                            if time < (Time.minute * 3) then
                                ans.hint
                            else
                                ""
                        _ ->
                            ""

                showAnswer =
                    div [ id "answer" ]
                        [ text ans.answer
                        , br [] []
                        , i [] [ text hint' ]
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
                            , i [] [ text ans.context ]
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
            let
                seconds =
                    (Time.inSeconds time)
                        |> floor
                        |> flip (%) 60
                        |> \s -> if s < 10 then "0" ++ (toString s) else toString s

                minutes =
                    (Time.inMinutes time)
                        |> floor
                        |> toString
            in
                div [ id "timer" ] [ text (minutes ++ ":" ++ seconds) ]

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
                          [ h2 [] [ col.label ]
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
main : Program Never
main =
    App.program { init = initModel
                , view = view
                , update = update
                , subscriptions = heartbeat
                }
