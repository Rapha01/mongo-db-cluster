rs.initiate({
  _id: 'configserver',
  configsvr: true,
  members: [
    {
      _id: 0,
      host: '10.0.0.3:27017',
    },
    {
      _id: 1,
      host: '10.0.0.4:27017',
    },
    {
      _id: 2,
      host: '10.0.0.5:27017',
    },
  ],
});
