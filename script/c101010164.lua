--created & coded by Lyris
--A Fated Encounter
function c101010164.initial_effect(c)
	--Banish from your Extra Deck, 1 monster that has a Level and 1 monster that does not have a Level, also, after that, Ritual Summon any number of "Fate's" Ritual Monsters from your hand whose total Levels exactly equal the sum of the indicator stars on the banished monsters. You can only use this effect of "A Fated Encounter" once per turn.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101010164)
	e1:SetTarget(c101010164.target)
	e1:SetOperation(c101010164.activate)
	c:RegisterEffect(e1)
end
function c101010164.spfilter(c,e,tp,mc1,mc2)
	return c:IsSetCard(0xf7a) and bit.band(c:GetType(),0x81)==0x81 and (not c.mat_filter or (c.mat_filter(mc1) and c.mat_filter(mc2)))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
		and mc1:IsCanBeRitualMaterial(c) and mc2:IsCanBeRitualMaterial(c)
end
function c101010164.filter(e,tp,m1,m2)
	local sg=Duel.GetMatchingGroup(c101010164.spfilter,tp,LOCATION_HAND,0,nil,e,tp,m1,m2)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	return sg:CheckWithSumEqual(Card.GetLevel,m1:GetLevel()+m2:GetRank(),1,ft)
end
function c101010164.mfilter1(c,e,tp)
	return c:GetLevel()>0 and c:IsAbleToRemove() and Duel.IsExistingMatchingCard(c101010164.mfilter2,tp,LOCATION_EXTRA,0,1,c,e,tp,c)
end
function c101010164.mfilter2(c,e,tp,fc)
	return c:GetRank()>0 and c:IsAbleToRemove() and c101010164.filter(e,tp,fc,c)
end
function c101010164.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101010164.mfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c101010164.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local mg=Duel.SelectMatchingCard(tp,c101010164.mfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local mc1=mg:GetFirst()
	local mg2=Duel.SelectMatchingCard(tp,c101010164.mfilter2,tp,LOCATION_EXTRA,0,1,1,mc1,e,tp,mc1)
	local mc2=mg2:GetFirst()
	if not mc1 or not mc2 then return end
	local mat=Group.FromCards(mc1,mc2)
	local sg=Duel.GetMatchingGroup(c101010164.spfilter,tp,LOCATION_HAND,0,nil,e,tp,mc1,mc2)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if sg:CheckWithSumEqual(Card.GetLevel,mc1:GetLevel()+mc2:GetRank(),1,ft) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:SelectWithSumEqual(tp,Card.GetLevel,mc1:GetLevel()+mc2:GetRank(),1,ft)
		local tc=tg:GetFirst()
		while tc do
			tc:SetMaterial(mat)
			tc=tg:GetNext()
		end
		Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		tc=tg:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
			tc=tg:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end
