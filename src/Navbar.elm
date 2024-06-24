module Navbar exposing (Model, Msg(..), defaultModel, nav)

import Html exposing (..)
import Html.Attributes as Attr
import Html.Events as Events


type alias Model =
    { logoPath : String
    , isBurgerIconClicked : Bool
    , navBarListItems : List ( String, String )
    }


type Msg
    = OnBurgerIconClicked


defaultModel : Model
defaultModel =
    { logoPath = "./assets/logo.png"
    , isBurgerIconClicked = False
    , navBarListItems = [ ( "My Account", "" ), ( "Sign-in", "" ), ( "Shopping Cart (0)", "" ) ]
    }


nav : Model -> Html Msg
nav model =
    Html.nav [ Attr.class "navbar has-shadow is-dark" ]
        [ navBarLogo model
        , navBarMenu model
        ]


navBarBurger : Html Msg
navBarBurger =
    Html.a [ Attr.class "navbar-burger" ]
        [ Html.span [] []
        , Html.span [] []
        , Html.span [] []
        , Html.span [] []
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnBurgerIconClicked ->
            ( model, Cmd.none )


navBarLogoDetails : Model -> Html Msg
navBarLogoDetails model =
    Html.a [ Attr.class "navbar-item", Attr.href model.logoPath ]
        [ Html.img
            [ Attr.src model.logoPath
            , Attr.alt "Site Logo"
            , Attr.style "max-height" "70px"
            , Attr.class "py-1 px-1"
            ]
            []
        ]


navBarLogo : Model -> Html Msg
navBarLogo model =
    Html.div
        [ Attr.class "navbar-brand"
        , Events.onClick OnBurgerIconClicked
        ]
        [ navBarLogoDetails model
        , navBarBurger
        ]


navItemList : ( String, String ) -> Html Msg
navItemList ( name, href ) =
    Html.a
        [ Attr.class "navbar-item", Attr.href href ]
        [ Html.text name ]


navBarMenuIsActive : Bool -> String
navBarMenuIsActive isActive =
    let
        navBar =
            "navbar-menu"
    in
    if isActive then
        navBar ++ " is-active"

    else
        navBar


navBarMenu : Model -> Html Msg
navBarMenu model =
    let
        items =
            List.map navItemList model.navBarListItems
    in
    Html.div
        [ Attr.class (navBarMenuIsActive model.isBurgerIconClicked)
        , Attr.id "nav-links"
        ]
        [ Html.div [ Attr.class "navbar-end" ]
            items
        ]
