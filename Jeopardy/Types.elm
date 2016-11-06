module Jeopardy.Types exposing (..)

import Html exposing (Html)
import Time exposing (Time)

{- TYPES -}

type alias Points = Int

type alias ID = Int

type alias ShowAnswer = Bool

type alias Column =
    { answers : List (ID, Answer)
    , label : Html Msg
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
