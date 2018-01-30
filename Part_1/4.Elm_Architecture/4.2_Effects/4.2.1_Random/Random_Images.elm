-- Random images version


module RandomImages exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random exposing (..)
import Array exposing (..)


main =
    Html.program { init = init, subscriptions = subscriptions, update = update, view = view }



-- MODEL


type alias Model =
    { dieFace : String
    , current : Int
    , faces : List String
    }


init : ( Model, Cmd Msg )
init =
    ( Model "https://picsum.photos/400/400/?image=575"
        0
        [ "https://picsum.photos/400/400/?image=575"
        , "https://picsum.photos/400/400/?image=60"
        , "https://picsum.photos/400/400/?image=69"
        , "https://picsum.photos/400/400/?image=120"
        , "https://picsum.photos/400/400/?image=300"
        , "https://picsum.photos/400/400/?image=420"
        ]
    , Cmd.none
    )



-- UPDATE


type Msg
    = Roll
    | NewFace Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model, Random.generate NewFace (Random.int 0 5) )

        NewFace int ->
            ( { model | dieFace = Maybe.withDefault "None" <| Array.get int <| Array.fromList model.faces, current = int }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text (toString (model.current + 1)) ]
        , img [ src model.dieFace ] []
        , br [] []
        , button [ onClick Roll ] [ text "Roll" ]
        ]
