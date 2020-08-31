/// @description Insert description here
// You can write your code in this editor

with (oPlayer)
{
	other.x = x;
	other.y = y;
}

if keyboard_check_released(vk_space)
{
	instance_destroy()	
}

image_speed= 0.2;