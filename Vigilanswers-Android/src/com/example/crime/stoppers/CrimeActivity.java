package com.example.crime.stoppers;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.StatusLine;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.ActionBar;
import android.app.AlertDialog;
import android.app.FragmentTransaction;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.location.Criteria;
import android.location.Location;
import android.location.LocationManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.Spinner;
import android.widget.TextView;

public class CrimeActivity extends FragmentActivity implements ActionBar.TabListener {

	final Context context = this;
	TextView title;
	TextView description;
	Spinner catagory;
	
	LocationManager locationManager;
	Location location;
	
	ListView results;
	List<JSONObject> reports;
	
	public void submit(View view) {
		
		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(context);
		alertDialogBuilder.setNeutralButton(android.R.string.ok, new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {
            }
        });
		
		if (!locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
			alertDialogBuilder.setTitle("GPS Alert");
			alertDialogBuilder.setMessage("You cannot submit a report without GPS data. Enable your GPS and then resubmit.");
			AlertDialog alertDialog = alertDialogBuilder.create();			
			alertDialog.show();
		}
		else {
			new PostTask().execute();
	    	title.setText("");
	    	description.setText("");
			alertDialogBuilder.setMessage("Report sucessfully submitted.");
			AlertDialog alertDialog = alertDialogBuilder.create();			
			alertDialog.show();
		}
	}
    
	private class PostTask extends AsyncTask<String, Void, String> {

		@Override
		protected String doInBackground(String... urls) {
			String response = "";
			
			HttpClient httpclient = new DefaultHttpClient();
		    HttpPost httppost = new HttpPost("http://lit-ridge-7864.herokuapp.com/reports/new");
			
		    Criteria criteria = new Criteria();
			String provider = locationManager.getBestProvider(criteria,true);
			location = locationManager.getLastKnownLocation(provider);
		    
		    try {
		    
		    	List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(5);
		    	
		    	nameValuePairs.add(new BasicNameValuePair("catagory", catagory.getSelectedItem().toString()));
		    	nameValuePairs.add(new BasicNameValuePair("title", title.getText().toString()));
		    	nameValuePairs.add(new BasicNameValuePair("description", description.getText().toString()));
		    	
		    	if (location == null) {
		    		nameValuePairs.add(new BasicNameValuePair("longitude", "-84.389954"));
			    	nameValuePairs.add(new BasicNameValuePair("latitude", "33.763747"));
		    	}
		    	else {
		    		nameValuePairs.add(new BasicNameValuePair("longitude", Double.toString(location.getLongitude())));
			    	nameValuePairs.add(new BasicNameValuePair("latitude", Double.toString(location.getLatitude())));
		    	}

		    	httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));
		    	httpclient.execute(httppost);
		    	
		    	response = "true";
		    }
		    catch (Exception e) {
		    	response = "false";
		    }
		    return response;
		}
		
		protected void onPostExecute(String result) {
			
		}
	}
	
	public void refresh(View view) {
		results = (ListView)view.findViewById(R.id.viewer);
    	/*reports = load();
    	for (int x = 0; x < reports.size(); x++) {
    		try {
    			Map<String, String> tempMap = new HashMap<String, String>();
				tempMap.put(reports.get(x).getString("title"), reports.get(x).getString("description").substring(0,20) +  "...");
				shortReports.add(tempMap);
			} catch (JSONException e) {
			}
    	}
    	*/
		String[] from = new String[] {"title", "description"};
		int[] to = new int[] { R.id.text1, R.id.text2 };
		List<HashMap<String, String>> output = new LinkedList<HashMap<String, String>>();
		HashMap<String, String> outputTemp = new HashMap<String, String>();
		outputTemp.put("title", "Robbery");
		outputTemp.put("description", "A student was robbed last night on the Georgia Tech campus...");
		output.add(outputTemp);
		outputTemp = new HashMap<String, String>();
		outputTemp.put("title", "Robbery");
		outputTemp.put("description", "A student was robbed last night on the Georgia Tech campus...");
		output.add(outputTemp);
		outputTemp = new HashMap<String, String>();
		outputTemp.put("title", "Murder");
		outputTemp.put("description", "Last weekend someone was murdered walking home form the grocery store...");
		output.add(outputTemp);
		outputTemp = new HashMap<String, String>();
		outputTemp.put("title", "RHoK");
		outputTemp.put("description", "RHoK is awesome!...");
		output.add(outputTemp);
    	SimpleAdapter adapter = new SimpleAdapter(
    			context,
    			output,
    			R.layout.idkaname,
    			from,
    			to
    			);
    	results.setAdapter(adapter);
	}
	
	public List<JSONObject> load() {
		String input = null;
		new LoadTask().execute(input);
		List<JSONObject> output = new LinkedList<JSONObject>();
	    
	    try {
			JSONArray reports = new JSONArray(input);
			for (int x = 0; x < reports.length(); x++) {
				output.add(reports.getJSONObject(x));
			}
		} catch (JSONException e) {
			try {
				output.add(new JSONObject("{\"title\":\"No reports found\"}"));
			} catch (JSONException e1) {
			}
		}
	    return output;
	}
	
	public class LoadTask extends AsyncTask<String, Void, String> {
		
		protected String doInBackground(String... params) {
			StringBuilder builder = new StringBuilder();
			HttpClient client = new DefaultHttpClient();
		    HttpGet httpGet = new HttpGet("http://lit-ridge-7864.herokuapp.com/reports");
		    try {
		        HttpResponse response = client.execute(httpGet);
		        StatusLine statusLine = response.getStatusLine();
		        if (statusLine.getStatusCode() == 200) {
		        	HttpEntity entity = response.getEntity();
		            InputStream content = entity.getContent();
		            BufferedReader reader = new BufferedReader(new InputStreamReader(content));
		            String line;
		            while ((line = reader.readLine()) != null) {
		              builder.append(line);
		            }
		        }
		    }
		    catch (ClientProtocolException e) {
		    	builder.append("{\"title\":\"No reports found\"}");

		    } catch (IOException e) {
		    	builder.append("{\"title\":\"No reports found\"}");
		    }
		    params[0] = builder.toString();
		    return params[0];
		}
		
		public void onPostExecute(String result) {
			
		}
	}
	
	public void map(View view) {
		//startActivity(new Intent(this, MapActivity.class));
	}
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
    	
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_crime);

        final ActionBar actionBar = getActionBar();
        actionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_TABS);
        
        actionBar.addTab(actionBar.newTab().setText(R.string.title_section1).setTabListener(this));
        actionBar.addTab(actionBar.newTab().setText(R.string.title_section2).setTabListener(this));
    	
    	locationManager = (LocationManager)getSystemService(Context.LOCATION_SERVICE);
    }

    @Override
    public void onRestoreInstanceState(Bundle savedInstanceState) {
       
    }

    @Override
    public void onSaveInstanceState(Bundle outState) {
    	
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.activity_crime, menu);
        return true;
    }

    

    public void onTabUnselected(ActionBar.Tab tab, FragmentTransaction fragmentTransaction) {
    }

    public void onTabSelected(ActionBar.Tab tab, FragmentTransaction fragmentTransaction) {
        if (tab.getText().equals("Reporting")) {
        	getSupportFragmentManager().beginTransaction()
            .replace(R.id.container, new ReportFragment())
            .commit();
        }
        else if (tab.getText().equals("Viewing")) {
        	getSupportFragmentManager().beginTransaction()
            .replace(R.id.container, new ViewFragment())
            .commit();
        }
    }

    public void onTabReselected(ActionBar.Tab tab, FragmentTransaction fragmentTransaction) {
    }
    
    public class ViewFragment extends Fragment {
    	
        public ViewFragment() {
        }

        @Override
        public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        	
        	View view = inflater.inflate(R.layout.view, container, false);
        	refresh(view);
        	return view;
        }
        
        
    }
    
    public class ReportFragment extends Fragment {
    	
        public ReportFragment() {
        	
        }

        @Override
        public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        	View view = inflater.inflate(R.layout.report, container, false);
        	title = (TextView)view.findViewById(R.id.title_input);
        	description = (TextView)view.findViewById(R.id.description_input);
            catagory = (Spinner)view.findViewById(R.id.catagory_spinner);
            ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(context, R.array.catagories, R.layout.spinner);
            adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
            catagory.setAdapter(adapter);
        	return view;
        }
    }
    
    public class ZoomViewFragment extends Fragment {
    	
    	
    	public ZoomViewFragment() {
    		
    	}
    	
    	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        	
        	View view = inflater.inflate(R.layout.zoom_view, container, false);
        	Bundle arguments = getArguments();
        	
        	//DISPLAY DATA
        	
        	return view;
        }
    	
    	public void done(View view) {
    		getFragmentManager().popBackStack();
    	}
    }
}
