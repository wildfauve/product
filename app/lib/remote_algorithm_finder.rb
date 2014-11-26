class RemoteAlgorithmFinder
  
  include Wisper::Publisher
  
  def search(host_name: nil)
    algs = RemoteAlgorithmsPort.new.search(url: host_name)
    store_algs(algs: algs.algs["algorithms"])
    publish(:remote_algs_success, algs.algs)
  end
  
  def store_algs(algs: nil)
    algs.each do |alg|
      Algorithm.find_or_replace(alg: alg)
    end
  end
end