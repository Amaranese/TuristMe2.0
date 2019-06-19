<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class User extends Model
{

    protected $table = 'users';
    protected $fillable = ['name', 'email', 'password','role_id'];

    public function role()
    {
        return $this->belongsTo('App\Role');
    }

    public function places()
    {
        return $this->hasMany('App\Place');
    }    
}
