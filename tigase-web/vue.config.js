
module.exports = {

  productionSourceMap: false,

  devServer: {
    proxy: {
      '/api/chat': {
        // target: 'http://192.168.0.101:5280',
        // target: 'http://10.20.5.122:5280',
        target: 'http://10.20.1.134:5280',
        pathRewrite:{
          '^/api/chat':''
        }
      }
    }
  }

}
