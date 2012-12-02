package com.example.crime.stoppers;

import java.util.ArrayList;

import android.content.Context;
import android.graphics.drawable.Drawable;

import com.google.android.maps.ItemizedOverlay;
import com.google.android.maps.OverlayItem;

public class NewItemizedOverlay extends ItemizedOverlay {

	private ArrayList<OverlayItem> overlays = new ArrayList<OverlayItem>();
	private Context context;
	
	public NewItemizedOverlay(Drawable marker, Context context) {
		super(boundCenterBottom(marker));
		this.context = context;
	}
	
	public NewItemizedOverlay(Drawable defaultMarker) {
		  super(boundCenterBottom(defaultMarker));
	}
	
	public void addOverlay(OverlayItem overlay) {
		overlays.add(overlay);
		populate();
	}
	
	@Override
	protected OverlayItem createItem(int input) {
		return overlays.get(input);
	}

	@Override
	public int size() {
		return overlays.size();
	}

}
