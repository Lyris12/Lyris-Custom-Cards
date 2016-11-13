--created & coded by Lyris
--Action Card - 
function c101010221.initial_effect(c)
local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101010221)
	e1:SetTarget(c101010221.target)
	e1:SetOperation(c101010221.activate)
	c:RegisterEffect(e1)
end
function c101010221.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x1613) and c:IsCanBeXyzMaterial(nil)
end
function c101010221.filter2(c,e,tp,g)
	return g:IsExists(c101010221.filter3,1,nil,c:GetRank()) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c101010221.filter3(c,rk)
	return c:GetLevel()==rk
end
function c101010221.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c101010221.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c101010221.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101010221.filter1,tp,LOCATION_MZONE,0,1,99,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101010221.filter4(c,e,tp)
	return c:IsFacedown() or c:IsControler(tp) or c:IsImmuneToEffect(e)
end
function c101010221.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if tg:FilterCount(Card.IsRelateToEffect,nil,e)~=tg:GetCount() or tg:IsExists(c101010221.filter4,1,nil,e,1-tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101010221.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tg)
	local sc=g:GetFirst()
	if sc then
		sc:SetMaterial(tg)
		Duel.Overlay(sc,tg)
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
