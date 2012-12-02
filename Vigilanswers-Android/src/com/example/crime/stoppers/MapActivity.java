package com.example.crime.stoppers;

import java.util.List;

import org.json.JSONObject;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapView;
import com.google.android.maps.Overlay;
import com.google.android.maps.OverlayItem;

import android.graphics.drawable.Drawable;
import android.os.Bundle;

public class MapActivity extends com.google.android.maps.MapActivity {

	@Override
	protected boolean isRouteDisplayed() {
		return false;
	}
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
	    super.onCreate(savedInstanceState);
	    setContentView(R.layout.map);
	    
	    MapView mapView = (MapView) findViewById(R.id.mapview);
	    mapView.setBuiltInZoomControls(true);
	    
	    List<Overlay> mapOverlays = mapView.getOverlays();
	    Drawable drawable = this.getResources().getDrawable(R.drawable.overlay);
	    NewItemizedOverlay itemizedoverlay = new NewItemizedOverlay(drawable, this);
	    
	    CrimeActivity resource = new CrimeActivity();
	    List<JSONObject> items = resource.load();
	    
	    for (int x = 0; x < items.size(); x++) {
	    	try {
	    	itemizedoverlay.addOverlay(new OverlayItem(
	    			new GeoPoint(
	    					(int)Double.parseDouble(items.get(x).getString("latitude")) * 1000000,
	    					(int)Double.parseDouble(items.get(x).getString("longitude")) * 1000000),
	    					items.get(x).getString("title"), ""));
	    	}
	    	catch (Exception e) {
	    		
	    	}
	    }
    	mapOverlays.add(itemizedoverlay);
	}

}
