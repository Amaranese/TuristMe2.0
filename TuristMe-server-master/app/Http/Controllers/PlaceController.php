<?php

namespace App\Http\Controllers;

use App\Place;
use App\User;
use Illuminate\Http\Request;
use \Firebase\JWT\JWT;

class PlaceController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $header = getallheaders();
        
        if ($header['Authorization'] != null) 
        {
            $userParams = JWT::decode($header['Authorization'], $this->key, array('HS256'));
            $places = Place::where('user_id', $userParams->id)->get();

            if(count($places) != 0)
            {
                return response()->json([
                    'MESSAGE' => $places
                ]);
            }else
            {
                return response()->json([
                    'MESSAGE' => 'Dont have any place created yet', 400
                ], 400); 
            }
        }
        else {
            return response()->json([
                'MESSAGE' => 'Dont have enough permission', 403
            ]);
        }
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $header = getallheaders();

        if ($header['Authorization'] != null) 
        {
            $userParams = JWT::decode($header['Authorization'], $this->key, array('HS256'));
            
            if ($user = User::where('email', $userParams->email)->first()) 
            {
                $place = new Place();
                if (empty($request->name) || empty($request->start_date) || empty($request->end_date)) 
                {
                    return response()->json([
                        'MESSAGE' => 'Some fields are empty'
                    ]);    
                }
                else {
                    $place->name = $request->name;
                    $place->description = $request->description;

                    $start_time = strtotime($request->start_date);
                    $newStartFormat = date('y-m-d', $start_time);
                    $place->start_date = $newStartFormat;

                    $end_time = strtotime($request->end_date);
                    $newEndFormat = date('y-m-d', $end_time);
                    $place->end_date = $newEndFormat;

                    $place->x_coordinate = $request->x_coordinate;
                    $place->y_coordinate = $request->y_coordinate;
                    $place->user_id = $user->id;
                    $place->save();

                    return response()->json([
                        'MESSAGE' => 200, 'The place has been created correctly'
                    ]); 
                }   
            }else{
                return response()->json([
                    'MESSAGE' => 403, 'Dont have enough permission'
                ]);
            } 
        }else {
            return response()->json([
                'MESSAGE' => 403, 'The user is not logged'
            ]);
        }
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Place  $place
     * @return \Illuminate\Http\Response
     */
    public function show(Place $place)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Place  $place
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, Place $place)
    {
        $header = getallheaders();

        $userParams = JWT::decode($header['Authorization'], $this->key, array('HS256'));
        if ($userParams->id == $place->user_id) {
            if (empty($request->name) || empty($request->start_date) || empty($request->end_date)) 
            {
                return response()->json([
                    'MESSAGE' => 411, 'Some fields are empty'
                ]);    
            }
            else {
                $place->name = $request->name;
                $place->description = $request->description;
                $place->start_date = $request->start_date;
                $place->end_date = $request->end_date;
                $place->x_coordinate = $request->x_coordinate;
                $place->y_coordinate = $request->y_coordinate;
                $place->save();
                return response()->json([
                    'MESSAGE' => 200, 'The place has been updated correctly'
                ]); 
            }
        }else {
            return response()->json([
                'MESSAGE' => 403, 'Dont have enough permission'
            ]);
        }
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Place  $place
     * @return \Illuminate\Http\Response
     */
    public function destroy(Place $place)
    {
    $header = getallheaders();

    if (!empty($header['Authorization'])) 
    {
        $userParams = JWT::decode($header['Authorization'], $this->key, array('HS256'));
        $places = Place::all();

        if ($user = User::where('email', $userParams->email)->first()) 
        {
            foreach ($places as $key => $place) {
                if ($place->user_id == $userParams->id) {
                    $place->delete();
                    return response()->json([
                        'MESSAGE' => 200, 'The place has been deleted correctly'
                    ]);
                } else {
                    return response()->json([
                        'MESSAGE' => 403, 'Dont have enough permission' 
                    ]);
                }
            }
        } else {
            return response()->json([
                    'MESSAGE' => 403, 'Dont have enough permission'
                ]);
            }
        }else{
            return response()->json([
                'MESSAGE' => 'The user is not logged'
            ]);
        }
    }
}
