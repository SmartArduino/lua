SensorID = "1"
status = "CLEAR"
oldstatus = "CLEAR"
server = "192.168.1.37"
port = 8888

function open()
  print("Open connection...")
  conn=net.createConnection(net.TCP, 0)
  conn:on("receive", function(conn, payload) print(payload) end) 
  conn:connect(port, server)
  conn:send("{ \"Type\":\"MAGSW\",\"SensorID\":\"".. SensorID .. "\"}")
end

function sendalarm(SensorID,status) 
   conn:send("{ \"Type\":\"MAGSW\",\"SensorID\":\"".. SensorID .. "\", \"Status\":\"".. status .."\"}")
end

function close()
  conn:close()
end

open()
sensorPin = 4
gpio.mode(sensorPin,gpio.INPUT,gpio.FLOAT)
tmr.alarm(0, 1000, 1, function() -- Set alarm to one second
     if gpio.read(sensorPin)==0 then status="ALARM" else status="CLEAR" end
    if status ~= oldstatus then sendalarm (SensorID,status) end
     oldstatus = status
end)





