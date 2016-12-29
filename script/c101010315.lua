--created & coded by Lyris
--RUM－ザ・ペア・ナンバーズ
function c101010315.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101010315.target)
	e1:SetOperation(c101010315.activate)
	c:RegisterEffect(e1)
end
function c101010315.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	e:SetLabel(Duel.AnnounceNumber(tp,1,2,3,4,5,6))
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c101010315.filter(c,e,tp,lv1,lv2)
	local lv=c:GetLevel()
	return (lv==lv1 or lv==lv2 or lv==lv1+lv2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010315.rfilter(c,e,tp,mc,rk)
	return c:GetRank()==rk and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c101010315.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv1=e:GetLabel()
	local lv2=Duel.TossDice(tp,1)
	local g1=Duel.SelectMatchingCard(tp,c101010315.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv1,lv2)
	local tc1=g1:GetFirst()
	if tc1 and Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP)~=0 and lv1==lv2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c101010315.rfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc1,lv2)
		local tc2=g2:GetFirst()
		if tc2 then
			Duel.BreakEffect()
			tc2:SetMaterial(g1)
			Duel.Overlay(tc2,g1)
			Duel.SpecialSummon(tc2,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			tc2:CompleteProcedure()
			e:GetHandler():CancelToGrave()
			Duel.Overlay(tc2,Group.FromCards(e:GetHandler()))
		end
	end
end
