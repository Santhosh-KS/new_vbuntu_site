module Main exposing (main)

-- import Browser

import Html exposing (..)
import Html.Attributes as Attr


view : Html msg
view =
    Html.div []
        [ Html.p [ Attr.class "title has-text-centered has-text-info has-background-dark" ]
            [ Html.text "Hello Elm" ]
        , Html.p
            [ Attr.class "subtitle has-text-centered has-text-warning has-background-light" ]
            [ Html.text "from Scratch " ]
        ]


main : Html msg
main =
    view
