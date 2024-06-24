{-
     module Main exposing (..)
   module Navbar exposing (Model, NavMsg(..), defaultModel, nav)
        import Html exposing (..)
        import Html.Attributes as Attr
        import Html.Events as Events


        type alias Model =
            { logoPath : String
            , isBurgerIconClicked : Bool
            , navBarListItems : List ( String, String )
            }


        type NavMsg
            = OnBurgerIconClicked


        defaultModel : Model
        defaultModel =
            { logoPath = "./assets/logo.png"
            , isBurgerIconClicked = False
            , navBarListItems = [ ( "My Account", "" ), ( "Sign-in", "" ), ( "Shopping Cart (0)", "" ) ]
            }


        nav : Model -> Html NavMsg
        nav model =
            Html.nav [ Attr.class "navbar has-shadow is-dark" ]
                [ navBarLogo model
                , navBarMenu model
                ]


        navBarBurger : Html NavMsg
        navBarBurger =
            Html.a [ Attr.class "navbar-burger" ]
                [ Html.span [] []
                , Html.span [] []
                , Html.span [] []
                , Html.span [] []
                ]


        update : NavMsg -> Model -> ( Model, Cmd Msg )
        update msg model =
            case msg of
                OnBurgerIconClicked ->
                    ( { model | isBurgerIconClicked = True }, Cmd.none )


        navBarLogoDetails : Model -> Html NavMsg
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


        navBarLogo : Model -> Html NavMsg
        navBarLogo model =
            Html.div
                [ Attr.class "navbar-brand"
                , Events.onClick OnBurgerIconClicked
                ]
                [ navBarLogoDetails model
                , navBarBurger
                ]


        navItemList : ( String, String ) -> Html NavMsg
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


        navBarMenu : Model -> Html NavMsg
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
-}


module Main exposing (..)
