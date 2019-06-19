<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Place extends Model
{
    protected $table = 'places';
    protected $fillable = ['name', 'description', 'start_date', 'end_date', 'x_coordinate', 'y_coordinate', 'user_id'];
    

    public function user()
    {
    	return $this->belongsTo('App\User');
    }

}
