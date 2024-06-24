module Main exposing (main)

import Browser
import Browser.Events
import Html exposing (..)
import Json.Decode
import Navbar exposing (..)


subscriptions : Model -> Sub Msg
subscriptions _ =
    Browser.Events.onResize ResizedWindow



-- MAIN


main : Program Json.Decode.Value Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { window : { width : Int, height : Int }
    , navBar : Navbar.Model
    }


type alias Flags =
    { windowWidth : Int
    , windowHeight : Int
    }


flagsDecoder : Json.Decode.Decoder Flags
flagsDecoder =
    Json.Decode.map2 Flags
        (Json.Decode.field "windowWidth" Json.Decode.int)
        (Json.Decode.field "windowHeight" Json.Decode.int)


init : Json.Decode.Value -> ( Model, Cmd Msg )
init json =
    case Json.Decode.decodeValue flagsDecoder json of
        Ok flags ->
            ( { window = { width = flags.windowWidth, height = flags.windowHeight }
              , navBar = Navbar.defaultModel
              }
            , Cmd.none
            )

        Err _ ->
            ( { window = { width = 0, height = 0 }
              , navBar = Navbar.defaultModel
              }
            , Cmd.none
            )



-- UPDATE


type Msg
    = OnNavbarClicked
    | ResizedWindow Int Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnNavbarClicked ->
            ( model, Cmd.none )

        ResizedWindow w h ->
            ( { model | window = { width = w, height = h } }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.text ("Width :" ++ String.fromInt model.window.width ++ "\n\nHeight :" ++ String.fromInt model.window.height)
        ]



-- Navbar.nav model.navBar
