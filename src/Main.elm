module Main exposing (main)

import Browser
import Html exposing (..)
import Navbar exposing (..)



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { navBar : Navbar.Model
    }


init : Model
init =
    { navBar = Navbar.defaultModel }



-- UPDATE


type Msg
    = None


update : Msg -> Model -> Model
update msg model =
    case msg of
        None ->
            model



-- VIEW


view : Model -> Html Msg
view model =
    Navbar.nav model.navBar
