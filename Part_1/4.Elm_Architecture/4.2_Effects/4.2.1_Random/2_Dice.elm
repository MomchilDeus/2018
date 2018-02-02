module TwoDice exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random exposing (..)


main =
    Html.program { init = init, subscriptions = subscriptions, update = update, view = view }



-- MODEL


type alias Model =
    { die1 : Int
    , die2 : Int
    }


init : ( Model, Cmd Msg )
init =
    ( Model 0 0, Cmd.none )



-- UPDATE


type Msg
    = Roll
    | NewFace1 Int
    | NewFace2 Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model
            , Cmd.batch
                [ Random.generate NewFace1 <| Random.int 1 6
                , Random.generate NewFace2 <| Random.int 1 6
                ]
            )

        NewFace1 int ->
            ( { model | die1 = int }, Cmd.none )

        NewFace2 int ->
            ( { model | die2 = int }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Roll ] [ text "Roll Dice" ]
        , h1 [] [ text <| toString model.die1 ]
        , h1 [] [ text <| toString model.die2 ]
        ]
