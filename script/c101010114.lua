--created & coded by Lyris
--アースの隠術
function c101010114.initial_effect(c)
--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(c101010114.target)
	e0:SetOperation(c101010114.activate)
	c:RegisterEffect(e0)
	--If this card is detached from an "Earth Enforcer" Xyz Monster and sent to the Graveyard to activate that monster's effect: You can target 1 "Earth Enforcer" monster you control; Special Summon 1 "Earth Enforcer" monster from your Extra Deck using it as the Xyz Material. (This Special Summon is treated as an Xyz Summon. Xyz Materials attached to that target also becomes Xyz Materials on the Summoned Monster.)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c101010114.spcon)
	e1:SetTarget(c101010114.sptg)
	e1:SetOperation(c101010114.spop)
	c:RegisterEffect(e1)
end
c101010114.earth_enforcer_list=true
function c101010114.filter(c,e,tp)
	return c:IsSetCard(0xeeb) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010114.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101010114.filter(chkc,e,tp) end
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101010114.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101010114.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101010114.xfilter(c)
	return c:IsSetCard(0xeeb) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c101010114.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c101010114.xfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,tc)
	if tc:IsRelateToEffect(e) and g:GetCount()>0 then
		local sc=g:Select(tp,1,1,nil)
		Duel.Overlay(tc,sc)
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) then
			Duel.BreakEffect()
			c:CancelToGrave()
			Duel.Overlay(tc,c)
		end
	end
end
function c101010114.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0xeeb)
		and bit.band(c:GetPreviousLocation(),LOCATION_OVERLAY)~=0
end
function c101010114.filter1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xeeb)
		and Duel.IsExistingMatchingCard(c101010114.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function c101010114.filter2(c,e,tp,mc)
	return c:IsSetCard(0xeeb) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c101010114.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c101010114.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c101010114.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101010114.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101010114.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101010114.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
