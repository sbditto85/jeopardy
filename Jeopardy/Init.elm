module Jeopardy.Init exposing (..)

import Html exposing (text, br, span)
import Jeopardy.Types exposing (..)
import Time

{- INIT -}
initModel :
    ( { columns : List ( ID, Column )
      , currentTeam : number
      , displayAnswer : Maybe a
      , showQuestion : Bool
      , teams : List ( ID, Team )
      , timer : Timer
      }
    , Cmd b
    )
initModel =
    let
        columns : List (ID, Column)
        columns = [ (0, { answers = [ (0, { answer = "The bread helps us remember this"
                                          , hint = "3 Nephi 18"
                                          , question = "What is Jesus Christ's Body"
                                          , context = "3 Nephi 18:7"
                                          , points = 100
                                          , show = True
                                          })
                                    , (1, { answer = "The water helps us remember this"
                                          , hint = "3 Nephi 18"
                                          , question = "What is Jesus Christ's blood (shed for us)?"
                                          , context = "3 Nephi 18:11"
                                          , points = 200
                                          , show = True
                                          })
                                    , (2, { answer = "Our promise when we take the sacrament"
                                          , hint = "3 Nephi 18"
                                          , question = "What is that we always remember Jesus Christ?"
                                          , context = "3 Nephi 18:7,11"
                                          , points = 300
                                          , show = True
                                          })
                                    , (3, { answer = "God's promise when we take the sacrament"
                                          , hint = "3 Nephi 18"
                                          , question = "What is that we will always have The Spirit with us?"
                                          , context = "3 Nephi 18:7,11"
                                          , points = 400
                                          , show = True
                                          })
                                    , (4, { answer = "What we are witnessing to God when we take the sacrement"
                                          , hint = "3 Nephi 18"
                                          , question = "What is that we are willing to do as God has commanded?"
                                          , context = "3 Nephi 18:10"
                                          , points = 500
                                          , show = True
                                          })
                                    ]
                        , label = span [] [ text "Sacrament"
                                          , br [] []
                                          , text "Promises"
                                          ]
                        })
                  , (1, { answers = [ (0, { answer = "What Jesus Christ asked his disciples to bring forth"
                                          , hint = "3 Nephi 18"
                                          , question = "What is bread and wine?"
                                          , context = "3 Nephi 18:1"
                                          , points = 100
                                          , show = True
                                          })
                                    , (1, { answer = "What Jesus Christ did with the bread"
                                          , hint = "3 Nephi 18"
                                          , question = "What is he broke it, blessed it, and gave it to his disciples and the people?"
                                          , context = "3 Nephi 18:3-4"
                                          , points = 200
                                          , show = True
                                          })
                                    , (2, { answer = "What Jesus Christ did with the wine"
                                          , hint = "3 Nephi 18"
                                          , question = "What is he blessed it, then passed it around for his disciples and the people to drink?"
                                          , context = "3 Nephi 18 8-9"
                                          , points = 300
                                          , show = True
                                          })
                                    , (3, { answer = "What must happen before you can administer the sacrament"
                                          , hint = "3 Nephi 18"
                                          , question = "What is be ordained?"
                                          , context = "3 Nephi 18:5"
                                          , points = 400
                                          , show = True
                                          })
                                    , (4, { answer = "Who we make covenants with when we take the sacrement"
                                          , hint = "3 Nephi 18"
                                          , question = "Who is the Father?"
                                          , context = "3 Nephi 18:7"
                                          , points = 500
                                          , show = True
                                          })
                                    ]
                        , label = span [] [ text "Sacrament"
                                          ]
                        })
                  , (2, { answers = [ (0, { answer = "The prophet that told the Nephites of the signs of Christ's birth"
                                          , hint = "3 Nephi 1:5"
                                          , question = "Samuel the Lamanite"
                                          , context = "3 Nephi 1:5"
                                          , points = 100
                                          , show = True
                                          })
                                    , (1, { answer = "The reason that Jesus Christ gave that people could be healed"
                                          , hint = "3 Nephi 17"
                                          , question = "What is Faith?"
                                          , context = "3 Nephi 17:8"
                                          , points = 200
                                          , show = True
                                          })
                                    , (2, { answer = "They way Jesus Christ showed that he loved the children"
                                          , hint = "3 Nephi 17"
                                          , question = "What is he took them and blessed them each one?"
                                          , context = "3 Nephi 17:21"
                                          , points = 300
                                          , show = True
                                          })
                                    , (3, { answer = "This happened to some of the people that saw the sign (Bad)"
                                          , hint = "3 Nephi 2:1-2"
                                          , question = "They stoped believing, as if they imagined it or it didn't happen"
                                          , context = "3 Nephi 2:1-2"
                                          , points = 400
                                          , show = True
                                          })
                                    , (4, { answer = "The day before Chirst's birth what did Nephi do"
                                          , hint = "3 Nephi 1:10-13"
                                          , question = "Prayed all day"
                                          , context = "3 Nephi 1:12"
                                          , points = 500
                                          , show = True
                                          })
                                    ]
                        , label = span [] [ text "Review"
                                          ]
                        })
                  , (3, { answers = [ (0, { answer = "your favorite Book of Mormon story"
                                          , hint = "this is your fav, you tell us"
                                          , question = "(you choose)"
                                          , context = ""
                                          , points = 100
                                          , show = True
                                          })
                                    , (1, { answer = "I was very rebelious leading many away from the church, until and angel came to visit me and then I became a missionary"
                                          , hint = "Mosiah 27"
                                          , question = "Alma the younger"
                                          , context = "Mosiah 27"
                                          , points = 200
                                          , show = True
                                          })
                                    , (2, { answer = "what Nephi, son of Lehi, said when asked to get the plates of brass"
                                          , hint = "1 Nephi 3"
                                          , question = "I will go and do the things which the Lord hath commanded, for I know the Lord doesn't give a commandment that he doesn't make a way to do"
                                          , context = "1 Nephi 3:7"
                                          , points = 300
                                          , show = True
                                          })
                                    , (3, { answer = "I asked God to touch some stones so that we could have light in our boats"
                                          , hint = "Ether 3"
                                          , question = "The brother of Jared"
                                          , context = "Ether 3"
                                          , points = 400
                                          , show = True
                                          })
                                    , (4, { answer = "the way we know the Book of Mormon is true"
                                          , hint = "Moroni 10"
                                          , question = "What is read, sincerely pray, and the Holy Ghost will tell you?"
                                          , context = "Moroni 10:3-5"
                                          , points = 500
                                          , show = True
                                          })
                                    ]
                        , label = span [] [ text "Random"
                                          , br [] []
                                          , text "BoM"
                                          , br [] []
                                          , text "scriptures"
                                          ]
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
         , showQuestion = False
         , currentTeam = 0
         , timer = Timing (Time.second * 0)
         } ! []
