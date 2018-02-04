module HTTP exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import Json.Decode as Decode exposing (..)


main =
    Html.program { init = init, subscriptions = subscriptions, update = update, view = view }



-- MODEL


type alias Model =
    { topic : String
    , gifUrl : String
    , message : String
    , showDropdown : Bool
    }


init : ( Model, Cmd Msg )
init =
    ( Model "" "https://media3.giphy.com/media/PBKe1OLngZck0/giphy.gif" "" False, Cmd.none )



-- UPDATE


type Msg
    = Generate
    | NewGif (Result Http.Error String)
    | Topic String
    | ShowDropdown
    | Topic1
    | Topic2
    | Topic3
    | Topic4
    | HideDropdown


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Generate ->
            ( { model | showDropdown = False }, getRandomGif model.topic )

        NewGif (Ok newUrl) ->
            ( { model | gifUrl = newUrl, message = "" }, Cmd.none )

        NewGif (Err _) ->
            ( { model | message = "No such topic" }, Cmd.none )

        Topic topic ->
            ( { model | topic = topic }, Cmd.none )

        ShowDropdown ->
            ( { model | showDropdown = True }, Cmd.none )

        Topic1 ->
            ( { model | topic = "Saoirse Ronan", showDropdown = False }, getRandomGif model.topic )

        Topic2 ->
            ( { model | topic = "Programming", showDropdown = False }, getRandomGif model.topic )

        Topic3 ->
            ( { model | topic = "Gaming", showDropdown = False }, getRandomGif model.topic )

        Topic4 ->
            ( { model | topic = "Sunrise", showDropdown = False }, getRandomGif model.topic )

        HideDropdown ->
            ( { model | showDropdown = False }, Cmd.none )



-- Define our getRandomGif


getRandomGif : String -> Cmd Msg
getRandomGif topic =
    let
        url =
            "https://api.giphy.com/v1/gifs/random?api_key=S4Owy81t3xC2ghtvSRk6Z3z7gqrhFdr3&tag=" ++ topic

        request =
            Http.get url decodeGifUrl
    in
        Http.send NewGif request



-- turns json into Elm
-- tries to find a string at json.data.image_url


decodeGifUrl : Decode.Decoder String
decodeGifUrl =
    Decode.at [ "data", "image_url" ] Decode.string



-- SUBSCRIPTIONS
-- add a subscription for mouseclicks -> close dropdown if user clicks somewhere else


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW
-- Add :hover effect on dropItems someday


view : Model -> Html Msg
view model =
    div [ style [ ( "text-align", "center" ), ( "width", "100%" ) ] ]
        [ input [ onInput Topic, placeholder "Choose a topic", inputStyle ] [ text model.topic ]
        , p [ style [ ( "margin-top", "5px" ) ] ] [ text ("Current topic: " ++ currentTopic model) ]
        , button [ onClick Generate, buttonStyle ] [ text "Random Gif" ]
        , br [] []
        , img [ src model.gifUrl, gifStyle ] []
        , p [ style [ ( "color", "red" ) ] ] [ text model.message ]
        , div [ onMouseOver ShowDropdown, onMouseOut HideDropdown, dropContainer ]
            [ button [ dropBtn ] [ text "Dropdown" ]
            , showDropdown model
            ]
        ]


inputStyle : Attribute Msg
inputStyle =
    style
        [ ( "width", "300px" )
        , ( "background", "white" )
        , ( "color", "#333" )
        , ( "border", "1px solid #333" )
        , ( "margin-top", "15px" )
        , ( "padding", "3px" )
        , ( "text-align", "center" )
        ]


currentTopic : Model -> String
currentTopic model =
    if model.topic == "" then
        "random"
    else
        model.topic


buttonStyle : Attribute Msg
buttonStyle =
    style
        [ ( "margin", "15px" )
        , ( "border-radius", "0" )
        , ( "border", "0" )
        , ( "padding", "10px 14px" )
        ]


gifStyle : Attribute Msg
gifStyle =
    style
        [ ( "max-width", "600px" )
        , ( "max-height", "400px" )
        ]



-- container div


dropContainer : Attribute Msg
dropContainer =
    style
        [ ( "width", "192px" )
        , ( "position", "absolute" )
        , ( "top", "15px" )
        , ( "left", "15px" )
        ]



-- dropdown toggler


dropBtn : Attribute Msg
dropBtn =
    style
        [ ( "background", "4CAF50" )
        , ( "color", "white" )
        , ( "padding", "16px" )
        , ( "border", "none" )
        , ( "cursor", "pointer" )
        , ( "width", "160px" )
        , ( "box-sizing", "content-box" )
        , ( "border", "1px solid #aaa" )
        ]


showDropdown : Model -> Html Msg
showDropdown model =
    let
        display =
            if model.showDropdown then
                "flex"
            else
                "none"
    in
        div
            [ style
                [ ( "display", display )
                , ( "flex-direction", "column" )
                , ( "margin", "auto" )
                ]
            ]
            [ a [ dropItem, onClick Topic1, href "#" ] [ text "Saoirse Ronan" ]
            , a [ dropItem, onClick Topic2, href "#" ] [ text "Programming" ]
            , a [ dropItem, onClick Topic3, href "#" ] [ text "Gaming" ]
            , a [ dropItem, onClick Topic4, href "#" ] [ text "Sunrise" ]
            ]



-- dropdown item


dropItem : Attribute Msg
dropItem =
    style
        [ ( "color", "#333" )
        , ( "padding", "12px 16px" )
        , ( "text-decoration", "none" )
        , ( "display", "inline-block" )
        , ( "border", "1px solid #aaa" )
        , ( "width", "160px" )
        ]
