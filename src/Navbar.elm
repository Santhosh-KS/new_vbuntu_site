module Navbar exposing (Model, defaultModel, nav)

import Html exposing (..)
import Html.Attributes as Attr


type alias Model =
    { logoPath : String
    , isBurgerIconClicked : Bool
    , navBarListItems : List ( String, String )
    }


defaultModel : Model
defaultModel =
    { logoPath = "./assets/logo.png"
    , isBurgerIconClicked = False
    , navBarListItems = [ ( "My Account", "" ), ( "Sign-in", "" ), ( "Shopping Cart (0)", "" ) ]
    }


nav : Model -> Html msg
nav model =
    Html.nav [ Attr.class "navbar has-shadow is-light" ]
        [ navBarLogo model
        , navBarMenu model
        ]


navBarBurger : Html msg
navBarBurger =
    Html.a [ Attr.class "navbar-burger" ]
        [ Html.span [] []
        , Html.span [] []
        , Html.span [] []
        , Html.span [] []
        ]


navBarLogoDetails : Model -> Html msg
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


navBarLogo : Model -> Html msg
navBarLogo model =
    Html.div [ Attr.class "navbar-brand" ]
        [ navBarLogoDetails model
        , navBarBurger
        ]


navItemList : ( String, String ) -> Html msg
navItemList ( name, href ) =
    Html.a
        [ Attr.class "navbar-item", Attr.href href ]
        [ Html.text name ]


navBarMenu : Model -> Html msg
navBarMenu model =
    let
        items =
            List.map navItemList model.navBarListItems
    in
    Html.div
        [ Attr.class "navbar-menu"
        , Attr.id "nav-links"
        ]
        [ Html.div [ Attr.class "navbar-end" ]
            items
        ]
