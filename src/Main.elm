module Main exposing (main)

import Browser
import Browser.Events
import Html exposing (..)
import Html.Attributes as Attr
import Html.Events as Events
import Json.Decode


subscriptions : Model -> Sub MainMsg
subscriptions _ =
    Browser.Events.onResize ResizedWindow



-- MAIN


main : Program Json.Decode.Value Model MainMsg
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
    , navBar : NavModel
    , breadCrumb : BreadCrumbModel
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


init : Json.Decode.Value -> ( Model, Cmd MainMsg )
init json =
    case Json.Decode.decodeValue flagsDecoder json of
        Ok flags ->
            ( { window = { width = flags.windowWidth, height = flags.windowHeight }
              , navBar = defaultModel
              , breadCrumb = { count = 0 }
              }
            , Cmd.none
            )

        Err _ ->
            ( { window = { width = 0, height = 0 }
              , navBar = defaultModel
              , breadCrumb = { count = 0 }
              }
            , Cmd.none
            )



-- UPDATE


type MainMsg
    = OnNavbarClicked
    | ResizedWindow Int Int


update : MainMsg -> Model -> ( Model, Cmd MainMsg )
update msg model =
    let
        flag =
            not model.navBar.isBurgerIconClicked
    in
    case msg of
        OnNavbarClicked ->
            ( { model
                | navBar =
                    { isBurgerIconClicked = flag
                    , logoPath = model.navBar.logoPath
                    , navBarListItems = model.navBar.navBarListItems
                    }
              }
            , Cmd.none
            )

        ResizedWindow w h ->
            ( { model | window = { width = w, height = h } }, Cmd.none )



-- VIEW


view : Model -> Html MainMsg
view model =
    Html.div []
        [ nav model.navBar
        , breadCrumb model.breadCrumb
        , productInfo model
        ]



-- NAV BAR Section


type alias NavModel =
    { logoPath : String
    , isBurgerIconClicked : Bool
    , navBarListItems : List ( String, String )
    }


defaultModel : NavModel
defaultModel =
    { logoPath = "./assets/logo.png"
    , isBurgerIconClicked = False
    , navBarListItems = [ ( "About", "" ), ( "blogs", "" ), ( "sign-in", "" ) ]
    }


nav : NavModel -> Html MainMsg
nav model =
    Html.nav [ Attr.class "navbar has-shadow is-dark" ]
        [ navBarLogo model
        , navBarMenu model
        ]


navBarBurger : Html MainMsg
navBarBurger =
    Html.a
        [ Attr.class "navbar-burger"
        , Events.onClick OnNavbarClicked
        ]
        [ Html.span [] []
        , Html.span [] []
        , Html.span [] []
        , Html.span [] []
        ]


navBarLogoDetails : NavModel -> Html MainMsg
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


navBarLogo : NavModel -> Html MainMsg
navBarLogo model =
    Html.div
        [ Attr.class "navbar-brand"
        ]
        [ navBarLogoDetails model
        , navBarBurger
        ]


navItemList : ( String, String ) -> Html MainMsg
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


navBarMenu : NavModel -> Html MainMsg
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



-- Bredcrumbs section


type alias BreadCrumbModel =
    { count : Int }


breadCrumb : BreadCrumbModel -> Html MainMsg
breadCrumb model =
    Html.section [ Attr.class "section pt-4 pb-0" ]
        [ Html.nav [ Attr.class "breadcrumb has-arrow-separator" ]
            [ Html.ul [ Attr.class "container" ]
                [ Html.li [ Attr.class "has-text-grey" ]
                    [ Html.a []
                        [ Html.text "vbuntu" ]
                    ]
                , Html.li [ Attr.class "has-text-grey" ]
                    [ Html.a []
                        [ Html.text "about" ]
                    ]
                , Html.li [ Attr.class "is-active" ]
                    [ Html.a []
                        [ Html.text "blog" ]
                    ]
                ]
            ]
        ]



-- Product info


productInfo : Model -> Html MainMsg
productInfo model =
    Html.section [ Attr.class "section" ]
        [ Html.div [ Attr.class "container" ]
            [ Html.div [ Attr.class "columns" ]
                [ Html.div [ Attr.class "column is-size-8" ]
                    [ Html.h1 [ Attr.class "title" ] [ Html.text "Mission" ]
                    , Html.p [] [ Html.text "Our mission is to foster a dynamic environment where engineers from diverse backgrounds come together to exchange knowledge, tackle challenges, and inspire one another.\nWe believe in the power of community-driven learning and the transformative impact it has on both individual growth and the advancement of engineering as a whole." ]
                    ]
                , Html.div [ Attr.class "column is-size-5" ]
                    [ Html.h1 [ Attr.class "title" ] [ Html.text "Vbuntu" ]
                    , Html.p [] [ Html.text "Vbuntu (V-Bunt-U). “Bunt” in German is “Colorful”. So “Vbuntu” means “We make You Colorful”, as a community." ]
                    ]
                ]
            ]
        , Html.div [ Attr.class "container" ]
            [ Html.div [ Attr.class "columns" ]
                [ Html.div [ Attr.class "column " ]
                    [ Html.h1 [ Attr.class "title" ] [ Html.text "Values" ]
                    , Html.p [] [ Html.text "At Vbuntu, we embrace the Ubuntu philosophy—a concept deeply rooted in African culture and widely popularized in the open-source community. Ubuntu emphasizes the interconnectedness of humanity and the principles of compassion, unity, and mutual support. Similarly, our community values reflect these ideals:" ]
                    ]
                ]
            ]
        , Html.div [ Attr.class "container" ]
            [ Html.div [ Attr.class "columns" ]
                [ Html.div [ Attr.class "column is-size-3" ]
                    [ Html.h1 [ Attr.class "title" ] [ Html.text "Inclusivity" ]
                    , Html.p [] [ Html.text "We celebrate diversity and welcome individuals from all backgrounds, disciplines, and skill levels. Everyone has a unique perspective to contribute." ]
                    ]
                , Html.div [ Attr.class "column is-size-3" ]
                    [ Html.h1 [ Attr.class "title" ] [ Html.text "Respect" ]
                    , Html.p [] [ Html.text "We promote a culture of mutual respect and constructive communication. Treat others with kindness and empathy." ]
                    ]
                , Html.div [ Attr.class "column is-size-3" ]
                    [ Html.h1 [ Attr.class "title" ] [ Html.text "Collaboration" ]
                    , Html.p [] [ Html.text "Great things happen when we work together. Collaboration fosters innovation and accelerates progress." ]
                    ]
                , Html.div [ Attr.class "column is-size-3" ]
                    [ Html.h1 [ Attr.class "title" ] [ Html.text "Community Building" ]
                    , Html.p [] [ Html.text " We believe in building strong, supportive communities where members lift each other up and strive for collective success." ]
                    ]
                ]
            ]
        ]



{- Embracing the Ubuntu Philosophy
   At Vbuntu, we embrace the Ubuntu philosophy—a concept deeply rooted in African culture and widely popularized in the open-source community. Ubuntu emphasizes the interconnectedness of humanity and the principles of compassion, unity, and mutual support. Similarly, our community values reflect these ideals:

   Inclusivity: We celebrate diversity and welcome individuals from all backgrounds, disciplines, and skill levels. Everyone has a unique perspective to contribute.

   Respect: We promote a culture of mutual respect and constructive communication. Treat others with kindness and empathy.

   Collaboration: Great things happen when we work together. Collaboration fosters innovation and accelerates progress.

   Community Building: We believe in building strong, supportive communities where members lift each other up and strive for collective success.
-}
