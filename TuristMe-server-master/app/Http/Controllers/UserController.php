<?php

namespace App\Http\Controllers;

use App\User;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use \Firebase\JWT\JWT;

class UserController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $header = getallheaders();
        $userParams = JWT::decode($header['Authorization'], $this->key, array('HS256'));
        if ($userParams->id == 1) {
            return User::where('role_id', 2)->get();
        }
        else
        {
            return response()->json([
                'MESSAGE' => 403, 'Dont have enough permission'
            ]);
        }
        
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        if (empty($request->name) || empty($request->password) || empty($request->email)) {
            return response()->json([
                'MESSAGE' => 'Some fields are null'], 401
            );
        } else {
            $user = new User();

            $user->name = str_replace(' ', '', $request->name);
            $user->email = $request->email;

            $users = User::where('email', $request->email)->get();
            foreach ($users as $key => $value) {
                if ($request->email == $value->email) {
                    return response()->json([
                        'MESSAGE' => 'The email is in use'], 401
                    );
                }
            }

            if (strlen($request->password) > 7)
            {
                $user->password = encrypt($request->password);
            } else 
            {
                return response()->json([
                    'MESSAGE' => 'The password must have more than seven characters'], 411
                );
            }
            $user->role_id = 2;

            $user->save();
            return response()->json([
                'MESSAGE' => 'The user has been register correctly'], 200
            );
        } 
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\GPASS  $gPASS
     * @return \Illuminate\Http\Response
     */
    public function show(UserController $user)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\GPASS  $gPASS
     * @return \Illuminate\Http\Response
     */
    public function edit(GPASS $gPASS)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\GPASS  $gPASS
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, User $user)
    {
        $header = getallheaders();

        if ($header['Authorization'] != null) 
        {
            try {
                $userLogged = JWT::decode($header['Authorization'], $this->key, array('HS256'));
                if ($userLogged->id == 1) 
                {
                    if (empty($request->name) || empty($request->email) || empty($request->password))
                    {
                        return response()->json([
                            'MESSAGE' => 'You have to change at least one field'], 400
                        );
                    }

                    $user->name = $request->name;

                    $users = User::where('email', $request->email)->get();
                    foreach ($users as $key => $value) {
                        if ($request->email == $value->email) {
                            return response()->json([
                                'MESSAGE' => 'The email is in use'], 401
                            );
                        }
                    }
                    $user->email = $request->email;
                    if (strlen($request->password) > 7)
                    {
                        $user->password = encrypt($request->password);
                    } else 
                    {
                    return response()->json([
                            'MESSAGE' => 'The password must have more than seven characters', 411
                        ]);
                    }
                    $user->save();
                    return response()->json([
                        'MESSAGE' => 'The user has been updated correctly'], 200
                    );
                } else {
                    return response()->json([
                        'MESSAGE' => 'Dont have enough permission'], 403
                    );
                }
            } 
            catch (Exception $e) 
            {
                return response()->json([
                    'MESSAGE' => 'Dont have enough permission'], 403
                );
            }
        }
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\GPASS  $gPASS
     * @return \Illuminate\Http\Response
     */
    public function destroy(User $user)     
    {
        $header = getallheaders();

        if ($header['Authorization'] != null) 
        {
            try {
                $userLogged = JWT::decode($header['Authorization'], $this->key, array('HS256'));
                if ($userLogged->id == 1) 
                {
                    $user->delete();
                    return response()->json([
                        'MESSAGE' => 'The user has been deleted correctly', 200
                    ]);
                } else {
                    return response()->json([
                        'MESSAGE' => 'Dont have enough permission', 403
                    ]);
                }
            } 
            catch (Exception $e) 
            {
                return response()->json([
                    'MESSAGE' => 'Dont have enough permission', 403
                ]);
            }
        }
    }
}
