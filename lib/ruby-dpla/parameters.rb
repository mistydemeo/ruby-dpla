require 'ruby-dpla/exceptions'


module DPLA
  module Parameters
 
 
# Here are the default paramters from the DPLA api ( https://github.com/dpla/platform/ )
 PARAMETERS = %w[
    api_key
    facets
    q
    @id
    id
    sourceResource
    sourceResource.contributor
    sourceResource.creator
    sourceResource.date.displayDate
    sourceResource.date.begin
    sourceResource.date.end
    sourceResource.description
    sourceResource.extent
    sourceResource.language.name
    sourceResource.language.iso639
    sourceResource.physicalMedium
    sourceResource.publisher
    sourceResource.rights
    sourceResource.relation
    sourceResource.stateLocatedIn.name
    sourceResource.stateLocatedIn.iso3166-2
    sourceResource.spatial.name
    sourceResource.spatial.country
    sourceResource.spatial.region
    sourceResource.spatial.county
    sourceResource.spatial.state
    sourceResource.spatial.city
    sourceResource.spatial.iso3166-2
    sourceResource.spatial.coordinates
    sourceResource.spatial.distance
    sourceResource.subject.@id
    sourceResource.subject.@type
    sourceResource.subject.name
    sourceResource.temporal.begin
    sourceResource.temporal.end
    sourceResource.title
    sourceResource.type
    dataProvider
    hasView
    hasView.@id
    hasView.format
    hasView.rights
    isPartOf
    isPartOf.@id
    isPartOf.name
    isShownAt
    isShownAt.@id
    isShownAt.format
    isShownAt.rights
    object
    object.@id
    object.format
    object.rights
    provider
    provider.@id
    provider.name 
      ]

  end
end