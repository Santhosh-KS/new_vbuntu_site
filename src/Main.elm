module Main exposing (main)

import Browser
import Browser.Events
import Html exposing (..)
import Html.Attributes as Attr
import Html.Events as Events
import Json.Decode
import String exposing (join)


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
    , tabDetails : TabDetailsModel
    }


type alias TabDetailsModel =
    { picture : Bool
    , music : Bool
    , santhosh : Bool
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
              , tabDetails = { picture = True, music = False, santhosh = False }
              }
            , Cmd.none
            )

        Err _ ->
            ( { window = { width = 0, height = 0 }
              , navBar = defaultModel
              , breadCrumb = { count = 0 }
              , tabDetails = { picture = True, music = False, santhosh = False }
              }
            , Cmd.none
            )



-- UPDATE


type MainMsg
    = OnNavbarClicked
    | ResizedWindow Int Int
    | OnPicturesTabClicked
    | OnMusicTabClicked
    | OnSanthoshTabClicked


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

        OnPicturesTabClicked ->
            ( { model
                | tabDetails =
                    { picture = True
                    , music = False
                    , santhosh = False
                    }
              }
            , Cmd.none
            )

        OnMusicTabClicked ->
            ( { model
                | tabDetails =
                    { picture = False
                    , music = True
                    , santhosh = False
                    }
              }
            , Cmd.none
            )

        OnSanthoshTabClicked ->
            ( { model
                | tabDetails =
                    { picture = False
                    , music = False
                    , santhosh = True
                    }
              }
            , Cmd.none
            )



-- VIEW


view : Model -> Html MainMsg
view model =
    Html.div []
        [ nav model.navBar
        , hero
        , breadCrumb model.breadCrumb
        , productInfo model
        , myTab model.tabDetails
        , myTabContent model.tabDetails

        -- , footer
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
navBarMenuIsActive flag =
    let
        navBar =
            "navbar-menu"
    in
    if flag then
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

                {- , Html.li [ Attr.class "is-active" ]
                   [ Html.a []
                       [ Html.text "blog" ]
                   ]
                -}
                ]
            ]
        ]



-- Product info


productInfoImage : Html MainMsg
productInfoImage =
    Html.div [ Attr.class "columns is-vcentered" ]
        [ Html.div [ Attr.class "column is-3" ]
            [ Html.img
                [ Attr.class "px-6 has-text-centered"
                , Attr.src "./assets/vbuntuWb.png"
                , Attr.style "max-width" "300px"
                , Attr.alt "Vbuntu"
                ]
                []
            ]
        , Html.div [ Attr.class "column " ]
            [ -- Html.h1 [ Attr.class "title" ] [ Html.text "Vbuntu" ]
              pTag ( "subtitle is-size-5 pb-4", "Vbuntu (V-Bunt-U). “Bunt” in German is “Colorful”. So “Vbuntu” means “We make You Colorful” as a community." )
            , h1Tag ( "title", "Mission" )
            , pTag ( "is-size-5", "Our mission is to foster a dynamic environment where engineers from diverse backgrounds come together to exchange knowledge, tackle challenges, and inspire one another.\nWe believe in the power of community-driven learning and the transformative impact it has on both individual growth and the advancement of engineering as a whole." )
            ]
        ]


productInfoValues : Html MainMsg
productInfoValues =
    Html.div [ Attr.class "columns" ]
        [ Html.div [ Attr.class "column " ]
            [ h1Tag ( "title", "Values" )
            , pTag ( "is-size-5", "At Vbuntu, we embrace the Ubuntu philosophy—a concept deeply rooted in African culture and widely popularized in the open-source community. Ubuntu emphasizes the interconnectedness of humanity and the principles of compassion, unity, and mutual support. Similarly, our community values reflect these ideals:" )
            ]
        ]


productInfoInclusivity : Html MainMsg
productInfoInclusivity =
    Html.div [ Attr.class "column is-size-3" ]
        [ h1Tag ( "title has-text-centered", "Inclusivity" )
        , pTag ( "is-size-6", "We celebrate diversity and welcome individuals from all backgrounds, disciplines, and skill levels. Everyone has a unique perspective to contribute." )
        ]


productInfoRespect : Html MainMsg
productInfoRespect =
    Html.div [ Attr.class "column is-size-3" ]
        [ h1Tag ( "title has-text-centered", "Respect" )
        , pTag ( "is-size-6", "We promote a culture of mutual respect and constructive communication. Treat others with kindness and empathy." )
        ]


productInfoCollaboration : Html MainMsg
productInfoCollaboration =
    Html.div [ Attr.class "column is-size-3" ]
        [ h1Tag ( "title has-text-centered", "Collaboration" )
        , pTag ( "is-size-6", "Great things happen when we work together. Collaboration fosters innovation and accelerates progress." )
        ]


productInfoCommunity : Html MainMsg
productInfoCommunity =
    Html.div [ Attr.class "column is-size-3" ]
        [ h1Tag ( "title has-text-centered", "Community" )
        , pTag ( "is-size-6", " We believe in building strong, supportive communities where members lift each other up and strive for collective success." )
        ]


productInfoDetails : Html MainMsg
productInfoDetails =
    Html.div [ Attr.class "columns pb-6" ]
        [ productInfoInclusivity
        , productInfoRespect
        , productInfoCollaboration
        , productInfoCommunity
        ]


productInfoWhatWeOffer : Html MainMsg
productInfoWhatWeOffer =
    Html.div [ Attr.class "columns is-vcentered" ]
        [ Html.div [ Attr.class "column" ]
            [ h1Tag ( "title", "What we offer" )
            , pTag ( "is-size-5", "In addition to being a hub for learning and collaboration, Vbuntu is committed to enhancing your productivity as an engineer. Here’s how we can help" )
            ]
        ]


productInfoKnowledgeSharing : Html MainMsg
productInfoKnowledgeSharing =
    Html.div [ Attr.class "column is-3" ]
        [ h1Tag ( "title has-text-centered", "Knowledge Sharing" )
        , pTag ( "is-size-6", "Dive into a treasure trove of resources ranging from technical articles and tutorials to insightful discussions on the latest industry trends. Our platform is designed to facilitate the exchange of ideas and best practices.\n\n" )
        ]


productInfoNetworking : Html MainMsg
productInfoNetworking =
    Html.div [ Attr.class "column is-6" ]
        [ h1Tag ( "title has-text-centered", "Networking" )
        , pTag ( "is-size-6", "Connect with like-minded professionals and enthusiasts. Forge meaningful relationships, find mentors or mentees, and expand your professional network. Projects and Challenges: Engage in collaborative projects and hands-on challenges that push the boundaries of innovation. Whether it’s a real world project you are working on or your side hustle. Unleash your creativity and problem-solving skills, by collaborating with the like mided people who wants to solve similar problem." )
        ]


productInfoEducationalEvent : Html MainMsg
productInfoEducationalEvent =
    Html.div [ Attr.class "column is-3" ]
        [ h1Tag ( "title has-text-centered", "Educational Events" )
        , pTag ( "is-size-6", "Participate in webinars, workshops, and seminars hosted by industry experts. Stay updated on emerging technologies and gain valuable insights from experienced practitioners. Share and inspire the next generation of Engineers, help them build their career and encourage them to be an entrepreneur. Help them build products which will have meaningful positive impact in people’s lives." )
        ]


productInfoBoosting : Html MainMsg
productInfoBoosting =
    Html.div [ Attr.class "columns is-vcentered pb-6" ]
        [ productInfoKnowledgeSharing
        , productInfoNetworking
        , productInfoEducationalEvent
        ]


productInfoProductivityChallenge : Html MainMsg
productInfoProductivityChallenge =
    Html.div [ Attr.class "column is-6" ]
        [ h1Tag ( "title has-text-centered", "Productivity Challenges" )
        , pTag ( "is-size-6", "Participate in productivity challenges designed to cultivate healthy habits and boost efficiency. We help in building systems that are simple, yet powerful enough to be used in any domain; which will help you achive your goals." )
        ]


productInfoPeerAccountability : Html MainMsg
productInfoPeerAccountability =
    Html.div [ Attr.class "column is-3" ]
        [ h1Tag ( "title has-text-centered", "Peer Accountability" )
        , pTag ( "is-size-6", "Join accountability groups within the community to stay motivated and accountable for your goals. Share your progress, celebrate achievements, and receive constructive feedback.\n\n" )
        ]


productInfoSkillDevelopment : Html MainMsg
productInfoSkillDevelopment =
    Html.div [ Attr.class "column is-3" ]
        [ h1Tag ( "title has-text-centered", "Skill Development" )
        , pTag ( "is-size-6", "Access tutorials and workshops focused on improving core engineering skills. Enhance your proficiency in software development, PCB design, CAD design, project management, and more.." )
        ]


h1Tag : ( String, String ) -> Html MainMsg
h1Tag ( header, body ) =
    Html.h1 [ Attr.class header ] [ Html.text body ]


pTag : ( String, String ) -> Html MainMsg
pTag ( header, body ) =
    Html.p [ Attr.class header ] [ Html.text body ]


productInfoPCPASD : Html MainMsg
productInfoPCPASD =
    Html.div [ Attr.class "columns is-vcentered pb-6" ]
        [ productInfoProductivityChallenge
        , productInfoPeerAccountability
        , productInfoSkillDevelopment
        ]


productInfo : Model -> Html MainMsg
productInfo model =
    Html.section [ Attr.class "section" ]
        [ Html.div [ Attr.class "container pb-6" ] [ productInfoImage ]
        , Html.div [ Attr.class "container pb-6" ] [ productInfoValues ]
        , Html.div [ Attr.class "container" ] [ productInfoDetails ]
        , Html.div [ Attr.class "container pb-6" ] [ productInfoWhatWeOffer ]
        , Html.div [ Attr.class "container pb-6" ] [ productInfoBoosting ]
        , Html.div [ Attr.class "container pb-6" ] [ productInfoPCPASD ]
        ]



-- footer
{- <footer class="footer">
     <div class="content has-text-centered">
       <p>
         <strong>Bulma</strong> by <a href="https://jgthms.com">Jeremy Thomas</a>.
         The source code is licensed
         <a href="http://opensource.org/licenses/mit-license.php">MIT</a>. The
         website content is licensed
         <a href="http://creativecommons.org/licenses/by-nc-sa/4.0/"
           >CC BY NC SA 4.0</a
         >.
       </p>
     </div>
   </footer>
-}


footer : Html MainMsg
footer =
    Html.footer [ Attr.class "footer" ]
        [ Html.div [ Attr.class "content has-text-centered" ]
            [ Html.p [ Attr.class "has-text-centered" ] [ Html.text "www.vbuntu.org" ]
            , Html.p [ Attr.class "has-text-right" ] [ Html.text "contact@vbuntu.org" ]
            ]
        ]



-- hero
{- <section class="hero is-primary">
     <div class="hero-body">
       <p class="title">Primary hero</p>
       <p class="subtitle">Primary subtitle</p>
     </div>
   </section>
-}


hero : Html MainMsg
hero =
    Html.section [ Attr.class "hero is-gray has-text-centered" ]
        [ Html.div [ Attr.class "hero-body" ]
            [ Html.p [ Attr.class "title" ] [ Html.text "VBUNTU" ]
            , Html.p [ Attr.class "subtitle" ] [ Html.text "We Make \"YOU\" colorful!" ]
            ]
        ]



-- Tabs
{- <div class="tabs">
     <ul>
       <li class="is-active"><a>Pictures</a></li>
       <li><a>Music</a></li>
       <li><a>Videos</a></li>
       <li><a>Documents</a></li>
     </ul>
   </div>
-}


lify : ( String, String, MainMsg ) -> Html MainMsg
lify ( data, visibility, event ) =
    Html.li [ Events.onClick event, joinClassAttributes [ visibility ] ] [ Html.a [] [ Html.text data ] ]


tabify : List ( String, String, MainMsg ) -> List (Html MainMsg)
tabify list =
    List.map lify list


joinClassAttributes : List String -> Attribute MainMsg
joinClassAttributes l =
    Attr.class (String.join " " l)


myTab : TabDetailsModel -> Html MainMsg
myTab model =
    Html.div [ joinClassAttributes [ "container", "tabs", "is-boxed", "pt-4", "pb-4" ] ]
        [ Html.ul []
            (tabify
                [ ( "Pictrues", isActive model.picture, OnPicturesTabClicked )
                , ( "Music", isActive model.music, OnMusicTabClicked )
                , ( "Santhosh", isActive model.santhosh, OnSanthoshTabClicked )
                ]
            )
        ]


isActive : Bool -> String
isActive flag =
    if flag then
        "is-active"

    else
        ""


myTabContent : TabDetailsModel -> Html MainMsg
myTabContent t =
    Html.div [ joinClassAttributes [ "container" ] ]
        [ myPictureData t.picture
        , myMusicData t.music
        , mySanthoshData t.santhosh
        ]


isActiveOrHidden : Bool -> String
isActiveOrHidden flag =
    if flag then
        "is-active"

    else
        "is-hidden"


myPictureData : Bool -> Html MainMsg
myPictureData flag =
    Html.div [ joinClassAttributes [ isActiveOrHidden flag ] ]
        [ pTag ( "", "Picture Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat." )
        ]


myMusicData : Bool -> Html MainMsg
myMusicData flag =
    Html.div [ joinClassAttributes [ isActiveOrHidden flag ] ]
        [ pTag ( "", "Music Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat." )
        ]


mySanthoshData : Bool -> Html MainMsg
mySanthoshData flag =
    Html.div [ joinClassAttributes [ isActiveOrHidden flag ] ]
        [ pTag ( "", "Santhosh Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat." )
        ]



{- myTabContent : Bool -> Html MainMsg
   myTabContent flag =
       let
           active =
               isActive flag
       in
       Html.div [ joinClassAttributes [ "container", active ] ]
           [ pTag ( "", "Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat." )
           ]
-}
